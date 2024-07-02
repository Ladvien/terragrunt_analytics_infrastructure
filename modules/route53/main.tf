
resource "aws_route53_zone" "primary" {
  name = var.domain
}

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
# resource "aws_route53_zone" "private" {
#   name = var.subdomain

#   vpc {
#     vpc_id = var.vpc_id
#   }
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.${var.domain}"
#   type    = "A"
#   ttl     = 300
#   # records = [aws_eip.lb.public_ip]
# }