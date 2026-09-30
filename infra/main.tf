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
