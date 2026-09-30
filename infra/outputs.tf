output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}
output "ec2_security_group_id" {
  description = "ID do SG da EC2"
  value       = module.security_group.ec2_security_group_id
}

output "rds_security_group_id" {
  description = "ID do SG do RDS"
  value       = module.security_group.rds_security_group_id
}
