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
    instance_type = "t2.micro"
    # subnet = dependency.vpc.outputs.
    minutes_after_save_to_shutdown = "10"
}
