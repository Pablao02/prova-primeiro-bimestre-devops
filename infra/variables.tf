variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "prova-devops"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}
variable "admin_cidr" {
  description = "CIDR permitido para acesso SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_name" {
  description = "Nome do banco PostgreSQL"
  type        = string
  default     = "reservas"
}

variable "db_username" {
  description = "Usuario do banco PostgreSQL"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha do banco PostgreSQL"
  type        = string
  sensitive   = true
}
