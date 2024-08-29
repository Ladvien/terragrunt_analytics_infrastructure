variable "region" {
    type = string
    description = "The region in which the S3 bucket will be created"  
}

variable "website_name" {
    type = string
    description = "The name of the website"
}

variable "domain" {
    type = string
    description = "The domain of the website"
}
