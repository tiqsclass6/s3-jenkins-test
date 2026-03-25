terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use latest version if possible
    }
  }

  backend "s3" {
    bucket  = "class-7-state-files"                # Name of the S3 bucket
    key     = "class-labs/s3-jenkins-test.tfstate" # The name of the state file in the bucket
    region  = "us-east-1"                          # Use a variable for the region
    encrypt = true                                 # Enable server-side encryption (optional but recommended)
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tiqs-jenkins-bucket" {
  bucket        = "tiqs-jenkins-webhook"
  force_destroy = true


  tags = {
    Name = "T.I.Q.S. Jenkins Webhook Bucket"
  }
}

resource "aws_s3_object" "pipeline" {
  bucket       = aws_s3_bucket.tiqs-jenkins-bucket.id
  key          = "jenkins-pipeline.jpg"
  source       = "${path.module}/images/jenkins-pipeline.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/jenkins-pipeline.jpg")
}

resource "aws_s3_object" "webhook" {
  bucket       = aws_s3_bucket.tiqs-jenkins-bucket.id
  key          = "jenkins-webhook.jpg"
  source       = "${path.module}/images/jenkins-webhook.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/jenkins-webhook.jpg")
}

resource "aws_s3_object" "suge-waf" {
  bucket       = aws_s3_bucket.tiqs-jenkins-bucket.id
  key          = "suge-waf.jpg"
  source       = "${path.module}/images/suge-waf.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/suge-waf.jpg")
}