terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # S3 버킷 이름 중복 방지용 random_id 사용을 위해 추가
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
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
