resource "aws_ses_domain_identity" "this_domain" {
  domain = var.domain
}

resource "aws_route53_record" "maddatum_amazonses_verification_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "300"
  records = [aws_ses_domain_identity.this_domain.verification_token]
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = var.domain
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${aws_ses_domain_dkim.dkim.dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_ses_domain_dkim.dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]
}


####################
# Mail From Domain
####################
resource "aws_ses_domain_mail_from" "this_domain" {
  domain           = aws_ses_domain_identity.this_domain.domain
  mail_from_domain = "mail.${var.domain}"
}

resource "aws_route53_record" "this_domain_mail_from_mx" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = aws_ses_domain_mail_from.this_domain.mail_from_domain
  type    = "MX"
  ttl     = "600"
    records = ["10 feedback-smtp.${var.region}.amazonses.com"]
}

resource "aws_route53_record" "this_domain_mail_from_spf" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = aws_ses_domain_mail_from.this_domain.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

# ########################
# # Primary Email Identity
# ########################

resource "aws_ses_email_identity" "primary_email" {
  email = var.primary_email
}

resource "aws_ses_domain_identity_verification" "primary_email_verification" {
  domain = var.primary_email
}

resource "aws_ses_domain_identity_verification" "this_domain_verification" {
  domain = var.domain
}


data "aws_iam_policy_document" "send_email_policy" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.this_domain.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

resource "aws_ses_identity_policy" "this_domain_policy" {
  identity = aws_ses_domain_identity.this_domain.arn
  name     = "send_email_policy"
  policy   = data.aws_iam_policy_document.send_email_policy.json
}