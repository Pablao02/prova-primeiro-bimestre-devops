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
