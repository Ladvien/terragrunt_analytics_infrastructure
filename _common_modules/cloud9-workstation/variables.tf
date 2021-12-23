variable "instance_type" {
  description = "The size of the Cloud9 workstation."
  default = ""
}

variable "subnet" {
    description = "The subnet for the workstation."
    default = ""
}

variable "minutes_after_save_to_shutdown" {
  description = "The number of minutes after the last save to shutdown the Cloud9 instance."
  default = ""
}

variable "project_name" {
  default = ""
}

variable "region" {
  default = ""
}