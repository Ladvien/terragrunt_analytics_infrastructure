terraform {
  source = "../../..//modules/serverless-sg"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    project_name                  = "health"
    department                    = "data_services"

    ingress_with_cidr_blocks = [
        {
            rule        = "all-traffic"
            cidr_blocks = "0.0.0.0/0"
        }
    ]

    egress_with_cidr_blocks = [
        {
            rule        = "all-traffic"
            cidr_blocks = "0.0.0.0/0"
        }
    ]

    vpc_id                        = dependency.vpc.outputs.vpc_id
}
