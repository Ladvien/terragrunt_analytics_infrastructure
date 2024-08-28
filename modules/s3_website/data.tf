provider "aws" {
  region = "us-east-1"
  alias = "useast1"
}

data "aws_acm_certificate" "issued" {
  provider = aws.useast1
  domain   = var.domain
  statuses = ["ISSUED"]
}


data "aws_route53_zone" "selected" {
  name         = var.domain
  private_zone = false
}

data "aws_cloudfront_distribution" "selected" {
  id = var.cloudfront_distribution_id
}