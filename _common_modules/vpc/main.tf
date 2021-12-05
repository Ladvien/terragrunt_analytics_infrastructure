module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_network_prefix}.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["${var.vpc_network_prefix}.1.0/24", "${var.vpc_network_prefix}.2.0/24", "${var.vpc_network_prefix}.3.0/24"]
  public_subnets  = ["${var.vpc_network_prefix}.101.0/24", "${var.vpc_network_prefix}.102.0/24", "${var.vpc_network_prefix}.103.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "${var.environment_name}"
  }

  nat_gateway_tags = {
    Project = "${var.project_name}"
    Terraform = "true"
    Environment = "${var.environment_name}"
  }
}