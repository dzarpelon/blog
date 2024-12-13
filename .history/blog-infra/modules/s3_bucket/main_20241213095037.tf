terraform {
    required_providers {
        hcp = {
            source = "hashicorp/hcp"
            version = "~>0.100"
        }
        aws = {
            source = "hashicorp/aws"
            version = "~>5.81"
        }
    }
}

# Fetch Secrets from HCP Vault

data "hcp_vault_secrets_app" "aws_free_tier" {
    app_name   = "AWSfreeTier"
}

provider "aws" {
    region = "eu-central-1"
    access_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_access_key_id"]
    secret_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_secret_access_key"]
}
#1. Create an S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket = "blog-bucket"
}
#2. Create an S3 bucket policy
resource "aws_s3_bucket_ownership_controls" "blog-bucket-policy" {
  bucket = aws_s3_bucket.blog-bucket-policy.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}