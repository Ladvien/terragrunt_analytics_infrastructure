data "http" "myip" {
    url = "http://ipv4.icanhazip.com"
}

data "aws_vpc" "vpc_id" {
    id = module.vpc.vpc_id
}

