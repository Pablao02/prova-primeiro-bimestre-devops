output "ec2_security_group_id" {
  description = "ID do Security Group da EC2"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "ID do Security Group do RDS"
  value       = aws_security_group.rds.id
}
