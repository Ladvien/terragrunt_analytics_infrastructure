terraform {
  source = "../../../..//_common_modules/airflow"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    subnets = dependency.vpc.outputs.vpc_private_subnets
    vpc_id = dependency.vpc.outputs.vpc_id
}
