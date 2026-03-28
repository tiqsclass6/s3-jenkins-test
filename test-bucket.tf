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

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tiqs_jenkins_bucket" {
  bucket        = "tiqsclass6-armageddon-public"
  force_destroy = true

  tags = {
    Name = "T.I.Q.S. Jenkins Webhook Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "tiqs_jenkins_bucket_block" {
  bucket = aws_s3_bucket.tiqs_jenkins_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.tiqs_jenkins_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.tiqs_jenkins_bucket_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.tiqs_jenkins_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "suge_waf" {
  bucket       = aws_s3_bucket.tiqs_jenkins_bucket.id
  key          = "suge-waf.jpg"
  source       = "${path.module}/images/suge-waf.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/suge-waf.jpg")
}

resource "aws_s3_object" "pipeline" {
  bucket       = aws_s3_bucket.tiqs_jenkins_bucket.id
  key          = "jenkins-pipeline.jpg"
  source       = "${path.module}/images/jenkins-pipeline.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/jenkins-pipeline.jpg")
}

resource "aws_s3_object" "webhook" {
  bucket       = aws_s3_bucket.tiqs_jenkins_bucket.id
  key          = "jenkins-webhook.jpg"
  source       = "${path.module}/images/jenkins-webhook.jpg"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/images/jenkins-webhook.jpg")
}

resource "aws_s3_object" "armageddon_readme" {
  bucket       = aws_s3_bucket.tiqs_jenkins_bucket.id
  key          = "armageddon.md"
  source       = "${path.module}/images/armageddon.md"
  content_type = "text/markdown"

  etag = filemd5("${path.module}/images/armageddon.md")
}