data "aws_vpc" "selected" {
  default = "false"
  state   = "available"
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"] # insert values here
  }
}
