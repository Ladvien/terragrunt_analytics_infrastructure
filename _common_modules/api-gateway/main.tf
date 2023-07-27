resource "aws_iam_role" "lambda_execution_role" {
    name = "${var.environment}-${var.project_name}-lambda-execution-role"
    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow"
            }
        ]
    })
}

resource "aws_iam_policy" "app_lambda_exec_policy" {
  name        = "${var.project_name}-lambda_exec-policy"
  description = "${var.project_name}-lambda_exec-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : []
  })
}

resource "aws_iam_role_policy_attachment" "app_lambda_exec_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.app_lambda_exec_policy.arn
}

resource "aws_lambda_function" "lambda" {

  filename      = "lambda.zip"
  function_name = "mylambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("${var.folder_to_lambda_source_code}/${local.source_code_paths[0]}")
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.environment}-${var.project_name}"
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "${var.environment}-${var.project_name}"
  description   = var.api_gateway_description
  protocol_type = "HTTP"


  body = templatefile(var.path_to_openapi_spec, {
    region = var.aws_region
    test_function_arn = aws_lambda_function.lambda.arn
  })

#   body = file(var.path_to_openapi_spec)

  cors_configuration = {
    allow_headers = [
      "content-type",
      "x-amz-date",
      "authorization",
      "x-api-key",
      "x-amz-security-token",
      "x-amz-user-agent"
    ]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

    create_routes_and_integrations = true
  create_api_domain_name = false # to control creation of API Gateway Domain Name
  # Custom domain
  #   domain_name                 = "terraform-aws-modules.modules.tf"
  #   domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

  # Access logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.this.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  #   integrations = {
  #     "POST /" = {
  #       lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
  #       payload_format_version = "2.0"
  #       timeout_milliseconds   = 12000
  #     }

  #     "GET /some-route-with-authorizer" = {
  #       integration_type = "HTTP_PROXY"
  #       integration_uri  = "some url"
  #       authorizer_key   = "azure"
  #     }

  #     "$default" = {
  #       lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
  #     }
  #   }

  #   authorizers = {
  #     "azure" = {
  #       authorizer_type  = "JWT"
  #       identity_sources = "$request.header.Authorization"
  #       name             = "azure-auth"
  #       audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
  #       issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
  #     }
  #   }

  tags = {
    Name = "http-apigateway"
  }
}

# resource "aws_api_gateway_rest_api" "this" {
#   name        = "${var.environment}-${var.project_name}"
#   description = var.api_gateway_description
#   body        = "${file(var.path_to_openapi_spec)}"
# }

locals {
  source_code_paths = tolist(fileset(var.folder_to_lambda_source_code, "*.py"))
}