
resource "aws_route53_zone" "primary" {
  name = var.domain
}


############################3
# Local to Region Certificates
############################3
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert-validations" {
  count = length(aws_acm_certificate.cert.domain_validation_options)

  zone_id = aws_route53_zone.primary.zone_id
  name    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)
  type    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)
  records = [element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index)]
  ttl     = 60
}


resource "aws_acm_certificate_validation" "cert-validation-record" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert-validations : record.fqdn
  ]
}

##################################################
# CloudFront Distribution Certificates (us-east-1)
##################################################
provider "aws" {
  region = "us-east-1"
  alias = "useast1"
}

resource "aws_acm_certificate" "cert_cloud_front" {
  # It appears we don't need to add verification for the CloudFront certificate
  # as the primary region's Route53 DNS records are used for validation.

  count = var.create_cloud_front_certificate ? 1 : 0
  provider = aws.useast1

  domain_name       = var.domain
  validation_method = "DNS"


  lifecycle {
    create_before_destroy = true
  }
}

