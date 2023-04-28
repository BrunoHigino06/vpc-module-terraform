provider "aws" {
  profile = "default"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment     = "Test"
      Service         = "Example"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1.0"
    }
  }
}