provider "aws" {
  region                   = var.AWS_REGION
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "anton"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.1"
    }
  }
}
