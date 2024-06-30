
resource "aws_route53_zone" "primary" {
  name = var.domain
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