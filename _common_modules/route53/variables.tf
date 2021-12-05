variable "vpc_id" {
  description = "The VPC ID associated with the Route53 resource."
  default = ""
}

variable "subdomain" {
  description = "subdomain"
  default = "sub.example.com"
}

variable "domain" {
  description = "subdomain"
  default = "example.com"
}
