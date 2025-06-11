terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"

  default_tags {
    tags = {
      Project     = "DevOps_Final"
      Environment = "Dev"
      Owner       = "Muhammad Asad ur Rehman Nadeem"
    }
  }
}
