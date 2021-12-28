terraform {
  source = "../../..//_common_modules/cloud9-workstation"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    instance_type                   = "t2.micro"
    minutes_after_save_to_shutdown  = "10"
    path_to_public_key              = "~/.ssh/workstation_key.pub"
    subnets                         = dependency.vpc.outputs.vpc_public_subnets
    allow_ssh_security_group_id     = dependency.vpc.outputs.allow_ssh_security_group_id
}
