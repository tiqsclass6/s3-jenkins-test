terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "class-7-state-files"                 # Name of the S3 bucket
    key     = "class-labs/s3-jenkins-test.tfstate"          # The name of the state file in the bucket
    region  = "us-east-1"                            # Use a variable for the region
    encrypt = true                                   # Enable server-side encryption (optional but recommended)
  } 
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "frontend" {
  bucket_prefix = "jenkins-bucket-"
  force_destroy = true
  

  tags = {
    Name = "Jenkins Bucket"
  }
}