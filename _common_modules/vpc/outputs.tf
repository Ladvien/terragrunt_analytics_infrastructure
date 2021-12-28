output "vpc_id" {
    description = "The VPC's ID."
    value       = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  description = "Private subnets output"
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  description = "Public subnets output"
  value = module.vpc.public_subnets
}

output "vpc_azs" {
  description = "Static availability zones output"
  value = module.vpc.azs
}

output "allow_ssh_security_group_id"  {
    value = aws_security_group.allow-ssh.id
}