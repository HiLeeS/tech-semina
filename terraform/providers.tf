terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      BusinessService = var.business_service
      Team            = var.team
      Environment     = var.environment
      CostCenter      = var.cost_center
      ManagedBy       = "terraform"
      Project         = "finops-tagging-strategy"
    }
  }
}
