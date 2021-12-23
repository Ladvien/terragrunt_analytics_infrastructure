# terraform {
#   source = "../../..//_common_modules/route53"
# }

# include {
#   path = find_in_parent_folders()
# }

# dependency "vpc" {
#   config_path = "../vpc"
# }

# inputs = {
#     domain = "maddatum.com"
#     subdomain = "almost"
#     vpc_id = dependency.vpc.outputs.vpc_id
# }
