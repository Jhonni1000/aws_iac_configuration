terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
}

provider "aws" {
    region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "aws-iac-config-19 "
    key    = "dev/terraform.tfstate"
    region = "eu-north-1"
  }
}