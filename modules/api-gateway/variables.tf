variable "aws_profile" {
  description = "AWS profile to use"
  default     = "default"
}

variable "aws_region" {
  description = "AWS region to use"
  default     = "us-west-2"
}

variable "environment" {
  default = ""
}

variable "project_name" {
  type    = string
  default = ""
}

variable "path_to_openapi_spec" {
  default     = ""
  description = "Path to OpenAPI spec file"
}

variable "api_gateway_description" {
  type        = string
  description = "Description of API Gateway"
}

variable "folder_to_lambda_source_code" {
    type = string
    description = "Folder to lambda source code"
}