variable "account" {
  type        = map(string)
  description = "The AWS account ID to deploy to"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to"
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "department" {
  type        = string
  description = "The department this project belongs to"
}

variable "kms_alias" {
  type        = string
  description = "The KMS alias to use for encrypting all resources, in-flight and rest."
}

variable "cpus" {
  type        = number
  description = "The number of CPU units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu is 1024. For tasks using the EC2 launch type, the minimum valid CPU value is 0.25 vCPU and the maximum is 4 vCPU."
}

variable "memory" {
  type        = number
  description = "The amount (in MiB) of memory used by the task. This is optional for tasks using the Fargate launch type and the total amount of container_memory is 4096. For tasks using the EC2 launch type, the minimum valid memory value is 512 MiB and the maximum is 30720 MiB."
}

variable "instance_name" {
  type        = string
  description = "The name of the instance"
}

variable "efs_id" {
  type        = string
  description = "The ID of the EFS file system"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block of the VPC"
}

variable "efs_security_group_id" {
  type        = string
  description = "The ID of the EFS security group"
}

variable "s3_code_bucket_name" {
  type        = string
  description = "The name of the S3 bucket where Dbt models are stored."
}

variable "kms_for_s3_bucket_arn" {
  type = string
  description = "The ARN of the KMS key used to encrypt the S3 code bucket"
}