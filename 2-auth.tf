terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "class-7-state-files"
    key     = "class-labs/s3-jenkins-test.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}