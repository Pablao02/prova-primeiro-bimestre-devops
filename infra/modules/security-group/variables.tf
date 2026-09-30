variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR permitido para SSH"
  type        = string
  default     = "0.0.0.0/0"
}
