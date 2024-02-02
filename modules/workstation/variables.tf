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

variable "startup_script_path" {
  type = string
  description = "Path to script to be executed on startup."
}

variable "python3_packages" {
  type = list(string)
  description = "Python3 packages to install on workstation."
}

variable "os_user_name" {
  type = string
  description = "The name of user in the workstation's OS."
}

variable "iam_role_for_workstation_name" {
  type = string
  description = "The role attached to the workstation. This ensures the workstation's AWS CLI is able to interact with resources."
}
