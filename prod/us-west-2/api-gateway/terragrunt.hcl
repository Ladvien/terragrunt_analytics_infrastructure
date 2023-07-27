terraform {
  source = "../../..//_common_modules/api-gateway"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    project_name                    = "PROJECT_NAME"
    api_gateway_description         = "Your Gateway API"
    path_to_openapi_spec            = "./open-api.yaml"

    folder_to_lambda_source_code    = "/path/to/lambda/code"
}
