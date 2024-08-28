terraform {
  source = "../../../..//modules/route53"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    domain = "prochesshabits.com"
    subdomain = "almost"
    vpc_id = dependency.vpc.outputs.vpc_id

    create_cloud_front_certificate = true
}
