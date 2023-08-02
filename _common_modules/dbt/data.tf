data "aws_security_group" "ssh" {
  filter {
    name   = "group-name"
    values = ["ssh-tcp*"]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*db*"] # insert values here
  }
}

data "aws_efs_file_system" "by_file_system_id" {
  file_system_id = var.efs_id
}

data "aws_vpc" "selected" {
  default = "false"
  state   = "available"
}

data "aws_kms_key" "by_alias" {
  key_id = var.kms_alias
}

data "aws_iam_policy_document" "access_to_s3_code_bucket_policy_document" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListAllMyBuckets",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_code_bucket_name}",
      "arn:aws:s3:::${var.s3_code_bucket_name}/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "kms:Decrypt",
    ]
    resources = [var.kms_for_s3_bucket_arn]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "dbt" {

  statement {
    actions = [
      "ecs:DescribeTasks"
    ]
    resources = [
      "arn:aws:ecs:${var.aws_region}:${var.account.account_id}:task/*",
    ]
    effect = "Allow"
  }

  # statement {
  #   actions = [
  #     "s3:GetBucketLocation",
  #     "s3:ListBucket",
  #     "s3:GetBucketAcl",
  #     "s3:GetObject",
  #     "s3:PutObject",
  #     "s3:DeleteObject",
  #     "s3:ListAllMyBuckets",
  #   ]
  #   resources = [
  #     "arn:aws:s3:::${var.s3_code_bucket_name}",
  #     "arn:aws:s3:::${var.s3_code_bucket_name}/*"
  #   ]
  #   effect = "Allow"
  # }

  statement {
    actions = [
      "ecs:RunTask",
      "ecs:StopTask"
    ]
    # Get everything until last : of ARN. We dont want a single revision, but ALL
    # If we only have access for revision, it will not work.
    # see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
    # "arn - Full ARN of the Task Definition (including both family and revision)."
    resources = [regex(".*[a-z]", aws_ecs_task_definition.task_dbt.arn)]
    effect    = "Allow"
  }

  statement {
    actions = [
      "efs:*"
    ]
    resources = [
      "${data.aws_efs_file_system.by_file_system_id.arn}",
      "${data.aws_efs_file_system.by_file_system_id.arn}/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::${var.account.account_id}:role/${local.execution_role_name}"
    ]
    effect = "Allow"
  }

}

data "aws_ecs_task_definition" "main" {
  depends_on      = [aws_ecs_task_definition.task_dbt]
  task_definition = aws_ecs_task_definition.task_dbt.family
}