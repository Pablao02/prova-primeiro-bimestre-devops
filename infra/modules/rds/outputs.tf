output "db_instance_id" {
  value = aws_db_instance.postgres.id
}

output "db_address" {
  value = aws_db_instance.postgres.address
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_port" {
  value = aws_db_instance.postgres.port
}
