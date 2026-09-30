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
output "ec2_instance_id" {
  description = "ID da instancia EC2"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "IP publico da EC2"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "DNS publico da EC2"
  value       = module.ec2.public_dns
}

output "rds_instance_id" {
  description = "ID da instancia RDS"
  value       = module.rds.db_instance_id
}

output "rds_address" {
  description = "Endereco privado do RDS"
  value       = module.rds.db_address
}

output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = module.rds.db_endpoint
}