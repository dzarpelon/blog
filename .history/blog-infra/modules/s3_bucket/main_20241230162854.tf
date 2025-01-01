terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.100"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.81"
    }
  }
}

provider "aws" {
  region     = "eu-central-1"
  access_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_access_key_id"]
  secret_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_secret_access_key"]
}

data "hcp_vault_secrets_app" "aws_free_tier" {
  app_name = "AWSfreeTier"
}

# 1. Create an S3 bucket
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = false
  }
  # on terraform destroy, delete all objects in the bucket
  force_destroy =  true
}

# 2. Create an S3 bucket policy
resource "aws_s3_bucket_policy" "s3-bucket-policy" {
  bucket = aws_s3_bucket.s3-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:*",
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.s3-bucket.arn}/*",
        Principal = "*",
      },
    ],
  })
}

# 3. Create S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "blog-bucket-ownership-controls" {
  bucket = aws_s3_bucket.s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}