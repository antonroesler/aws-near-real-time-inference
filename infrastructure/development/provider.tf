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

  # backend "s3" {
  #   bucket         = "tf-signal-detection-backend"
  #   key            = "state/terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "tf-signal-detection-lock-db"
  # }
}
