terraform {
  source = "../../..//_common_modules/airflow"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    
}
