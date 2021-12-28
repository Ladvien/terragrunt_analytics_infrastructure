variable "instance_type" {
  description = "The size of the EC2 workstation."
  default = ""
}

variable "subnet" {
    description = "The subnet for the workstation."
    default = ""
}

variable "project_name" {
  default = ""
}

variable "region" {
  default = ""
}

variable "centos_ami" {}

variable "subnets" {
  type = list
}

variable "path_to_public_key" {}

variable "allow_ssh_security_group_id" {}

variable "startup_script" {
  type = string
  description = "Path to script to be executed on startup."
}

variable "aws_cli_creds_path" {
  type = string
  description = "Path to local AWS credentials file."
}