variable "domain" {
    description = "The domain name to use for the SES domain identity"
    type = string
}

variable "primary_email" {
    type = string
    description = "The primary email address to use for the SES domain identity"
}

variable "region" {
    type = string
    description = "The region to use for the SES domain identity"
}