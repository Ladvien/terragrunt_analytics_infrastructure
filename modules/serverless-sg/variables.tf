
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
variable "department" {}
variable "ingress_with_cidr_blocks" {
  type = list(map(string))
}
variable "egress_with_cidr_blocks" {
  type = list(map(string))
}
variable "egress_with_source_security_group_id" {
  type = list(map(string))
  default = [ {} ]
}
variable "ingress_with_source_security_group_id" {
  type = list(map(string))
  default = [ {} ]
}
variable "vpc_id" {}