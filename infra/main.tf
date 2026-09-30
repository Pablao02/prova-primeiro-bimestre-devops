terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "prova-devops-terraform-state-6325076"
    key            = "prova-primeiro-bimestre-devops/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prova-devops-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "prova-primeiro-bimestre-devops"
      Environment = "prova"
      Owner       = "6325076"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = var.azs
}
module "security_group" {
  source = "./modules/security-group"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  admin_cidr   = var.admin_cidr
}
module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_group.rds_security_group_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  instance_class     = "db.t3.micro"
}

module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  public_subnet_ids     = module.vpc.public_subnet_ids
  security_group_id     = module.security_group.ec2_security_group_id
  instance_type         = "t2.micro"
  instance_profile_name = "LabInstanceProfile"

  db_host     = module.rds.db_address
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}