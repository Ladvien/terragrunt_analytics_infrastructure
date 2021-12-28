terraform {
  source = "../../..//_common_modules/workstation"
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
   
    aws_cli_creds_path              = "~/.aws/cthomasbrittain_admin_creds"

    startup_script                  = <<-EOF
#!/bin/bash

######################################
# General instance Setup
######################################
sudo su
yum update -y
yum install -y git \
               python3 \
               python3-pip \
               epel-release \
               amazon-linux-extras \
               awscli

######################################
# Download Airflow Setup Script
######################################
su centos
git clone https://github.com/Ladvien/airflow_setup.git
EOF
}
