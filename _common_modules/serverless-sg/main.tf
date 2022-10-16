locals {
  tags = {
    Name = "${var.project_name}"
    department = "${var.department}"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "${var.project_name}-sg"
  description = "${var.project_name} security group"
  vpc_id      = var.vpc_id

  computed_ingress_with_cidr_blocks     = var.ingress_with_cidr_blocks
  computed_egress_with_cidr_blocks      = var.egress_with_cidr_blocks
  tags = local.tags
}
