
# GLOBAL
variable "environment" {
  description = "Environment"
  default     = "prod"
}

variable "aws_profile" {
  description = "AWS profile to use"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to use"
  default     = "us-west-2"
}

# APPLICATION

variable "project_name" {}
variable "engine" {}
variable "engine_version" {}
variable "username" {}
variable "password" {
  type = string
}
variable "monitoring_interval" {}
variable "create_monitoring_role" {}
variable "family" {}
variable "vpc_cidr_block" {}
variable "vpc_id" {}

variable "instance_class" {
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  default = "5"
}

variable "multi_az" {
  default = "false"
}

variable "backup_retention_period" {
  default = "3"
}


variable "port" {
  type = string
  description = "The port number for remote access of the RDS instance."
}

variable "db_parameters" {
  type = list
  description = "The parameters to apply to the RDS instance."
}

variable "db_name" {
  type = string
  description = "Name of initial database."
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
  description = "CloudWatch export logs to enable."
}

variable "max_allocated_storage" {
  type = string
  description = "The maximum amount disk space RDS allowed use."
}

variable "department" {
  type = string
  description = "The department owner."
}

variable "subnet_name" {}

variable "publicly_accessible" {
  type = bool
  default = false
}

variable "apply_immediately" {
  type = bool
  default = false
  description = "Should changes to RDS be applied immediately or during maintenance."
}