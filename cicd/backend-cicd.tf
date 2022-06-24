terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Lock version to avoid unexpected problems
      version = "3.67"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
  backend "s3" {
    bucket         = "tf-state-ip-172-31-78-18-1656092965593858851"
    key            = "terraform/terraform_locks_cicd.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_locks_cicd"
    encrypt        = "true"
  }
}
provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.profile
}
