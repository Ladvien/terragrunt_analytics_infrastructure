terraform {
  source = "../../..//_common_modules/vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
    vpc_name = "ladviens-analytics-stack"
}
