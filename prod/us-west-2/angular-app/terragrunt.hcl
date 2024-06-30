terraform {
  source = "../../..//modules/webapp"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    instance_type                   = "t2.micro"
    path_to_public_key              = "~/.ssh/workstation_key.pub"
    subnets                         = dependency.vpc.outputs.vpc_public_subnets
    allow_ssh_security_group_id     = dependency.vpc.outputs.allow_ssh_security_group_id
    
    os_user_name                    = "angular-app"

    startup_script_path             = "./scripts/startup.tpl" 
    python3_packages                = [
      "rich",
      "numpy",
      "pandas"
    ]
}

# Move user data to "template_file"
# Add variables for AWS_PROFILE 
# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file