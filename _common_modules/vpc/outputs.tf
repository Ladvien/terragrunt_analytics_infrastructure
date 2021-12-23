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

# output "vpc_subnet_id" {
#   description = "The VPC's subnet ID."
#   value = module.vpc.private_subnets[0].id
# }