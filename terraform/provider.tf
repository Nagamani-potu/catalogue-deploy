terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.15"  # or latest stable version
    }
  }

  backend "s3" {
    bucket         = "state-dev-devopstraining"
    key            = "catalogue"
    region         = "us-east-1"
    dynamodb_table = "devops-locking-dev"
  }
}

provider "aws" {
  region = "us-east-1"
}