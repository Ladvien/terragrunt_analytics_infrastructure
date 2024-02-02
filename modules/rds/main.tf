
locals {
  tags = {
    Name = "${var.project_name}"
    department = "${var.department}"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  # version = "~> 4.0"

  name        = "${var.project_name}-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "RDS access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "RDS access from within VPC"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}


resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids

  tags = local.tags
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "${var.environment}-${var.project_name}"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family # DB parameter group
  major_engine_version = split(".", var.engine_version)[0]
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = var.db_name
  username = var.username
  password = var.password
  create_random_password = false
  port     = var.port

  multi_az                = var.multi_az
  db_subnet_group_name    = aws_db_subnet_group.default.name
  subnet_ids              = data.aws_subnets.subnets.ids
  vpc_security_group_ids  = [module.security_group.security_group_id]
  create_db_subnet_group  = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group     = true

  publicly_accessible             = var.publicly_accessible

  backup_retention_period         = var.backup_retention_period
  create_monitoring_role          = var.create_monitoring_role
  monitoring_interval             = var.monitoring_interval

  apply_immediately               = var.apply_immediately
  # skip_final_snapshot     = true
  # deletion_protection     = false

  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7
  # monitoring_role_name                  = "example-monitoring-role-name"
  # monitoring_role_use_name_prefix       = true
  # monitoring_role_description           = "Description for monitoring role"

  parameters = var.db_parameters

  # tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }

  tags = local.tags
}
