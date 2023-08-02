# Reads:
# https://data-dive.com/deploy-dbt-on-aws-using-ecs-fargate-with-airflow-scheduling/
# https://medium.com/hashmapinc/deploying-and-running-dbt-on-aws-fargate-872db84065e4
# https://gitlab.com/snowflakeproto/dbtonawsfargate

# Dbt
# https://pypi.org/project/dbt-athena-community/
# https://docs.getdbt.com/docs/core/connect-data-platform/athena-setup

# ECR
# https://github.com/awslabs/amazon-ecr-credential-helper

resource "aws_cloudwatch_log_group" "dbt_log_group" {
  name = "/ecs/${var.project_name}-log-group"
}

resource "aws_ecr_repository" "repo_dbt" {
  name                 = "${var.project_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_efs_access_point" "access_point" {
  file_system_id = data.aws_efs_file_system.by_file_system_id.id

  root_directory {
    path = "/dbt"
    creation_info {
      owner_uid   = "1000"
      owner_gid   = "1000"
      permissions = "777"
    }
  }
}

resource "aws_security_group_rule" "access_to_efs" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = var.efs_security_group_id
}

resource "aws_ecs_task_definition" "task_dbt" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpus
  memory                   = var.memory

  # This is the role of the agent / runner, need to pull images etc.
  execution_role_arn = "arn:aws:iam::${var.account.account_id}:role/${local.execution_role_name}"

  # Role used INSIDE the container, i.e. used when making API calls from within task
  task_role_arn = "arn:aws:iam::${var.account.account_id}:role/${local.task_role_name}"

  # TODO: Make sure to first push image
  container_definitions = <<CONTAINER_DEFINITION
    [
        {
            "name": "${var.project_name}",
            "image": "${aws_ecr_repository.repo_dbt.repository_url}",
            "environment": [
                {
                    "name": "ENV",
                    "value": "${var.environment}"
                },
                {
                  "name": "instance_name",
                  "value": "${var.instance_name}"
                }
            ],
            "mountPoints": [
                {
                    "sourceVolume": "dbt",
                    "containerPath": "/dbt"
                }
            ],
            "cpu": 512,
            "memory": 1024,
            "essential": true,
            "portMappings": [ 
              { 
                "containerPort": 22,
                "hostPort": 22,
                "protocol": "tcp"
              },
              { 
                "containerPort": 2049,
                "hostPort": 2049,
                "protocol": "tcp"
              }
            ],
            "logConfiguration": {
                "logDriver": "awslogs",
                "secretOptions": null,
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.dbt_log_group.name}",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-stream-prefix": "ecs"
                }
            }
        }
    ]
  CONTAINER_DEFINITION

  volume {
    name = "dbt"

    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.by_file_system_id.id
      # root_directory          = "/opt/data"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.access_point.id
        iam             = "ENABLED"
      }
    }
  }

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_iam_role" "dbt" {
  name                 = local.task_role_name
  description          = "Role for running dbt"
  max_session_duration = "7200"

  managed_policy_arns = [
    aws_iam_policy.dbt.arn
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowECSToAssumeRole"
        Principal = {
          # Allow those services to assume this role "run as this role on execution"
          Service = ["ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_policy" "access_to_s3_code_bucket_policy" {
  name        = "access_to_s3_code_bucket_policy"
  description = "Allow access to S3 code bucket"
  policy      = data.aws_iam_policy_document.access_to_s3_code_bucket_policy_document.json
}

resource "aws_iam_role_policy_attachment" "access_to_s3_code_bucket_policy_attachment" {
  role       = aws_iam_role.dbt.name
  policy_arn = aws_iam_policy.access_to_s3_code_bucket_policy.arn
}


resource "aws_iam_role" "ecs_task_execution" {
  name                 = local.execution_role_name
  description          = "For running ECS task agent"
  max_session_duration = "7200"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowECSToAssumeRole"
        Principal = {
          # Allow those services to assume this role "run as this role on execution"
          Service = ["ecs-tasks.amazonaws.com"]
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = [aws_iam_role.dbt.arn]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "dbt" {
  name        = var.project_name
  path        = "/"
  description = "Add to custom dbt service Role"
  policy      = data.aws_iam_policy_document.dbt.json
}

resource "aws_ecs_cluster" "dbt_cluster" {
  name = var.project_name

  configuration {
    execute_command_configuration {
      kms_key_id = data.aws_kms_key.by_alias.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.dbt_log_group.name
      }
    }
  }
}

resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs"
  description = "Allow access to EFS from ECS"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "EFS mount target access"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description = "Transit encryption"
    from_port   = 2999
    to_port     = 2999
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.project_name}-ecs-service"
  cluster              = aws_ecs_cluster.dbt_cluster.id
  task_definition      = aws_ecs_task_definition.task_dbt.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  enable_execute_command = true

  network_configuration {
    subnets          = data.aws_subnets.private_subnets.ids
    assign_public_ip = true
    security_groups = [
      # aws_security_group.service_security_group.id,
      # aws_security_group.load_balancer_security_group.id
      aws_security_group.efs.id,
      data.aws_security_group.ssh.id
    ]
  }

  #   load_balancer {
  #     target_group_arn = aws_lb_target_group.target_group.arn
  #     container_name   = "${var.app_name}-${var.app_environment}-container"
  #     container_port   = 6789
  #   }

  # depends_on = [aws_lb_listener.listener]
}

locals {
  execution_role_name = "${var.project_name}-ecs-task-execution"
  task_role_name      = "${var.project_name}-DBTServiceRole"
}