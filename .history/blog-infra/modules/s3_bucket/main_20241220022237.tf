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


resource "aws_s3_bucket_policy" "s3-bucket-policy" {
  bucket = aws_s3_bucket.s3-bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = var.oai_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.s3-bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object_acl" "object_acl" {
  bucket = aws_s3_bucket.s3-bucket.id
  key    = "index.html"

  acl = "bucket-owner-full-control"

  grant {
    id          = var.oai_id
    type        = "CanonicalUser"
    permission  = "READ"
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
resource "aws_s3_bucket" "s3-bucket" {
    bucket = "dzblog-blog-bucket"

}
#2. Create an S3 bucket policy
resource "aws_s3_bucket_ownership_controls" "blog-bucket-ownership-controls" {
  bucket = aws_s3_bucket.s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
#3 block public access

resource "aws_s3_bucket_public_access_block" "blog-bucket-public-access-block" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "blog-bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.blog-bucket-ownership-controls,
    aws_s3_bucket_public_access_block.blog-bucket-public-access-block,
  ]

  bucket = aws_s3_bucket.s3-bucket.id
  acl    = "private"
}

#4 Enable versioning

resource "aws_s3_bucket_versioning" "block-bucket-versioning" {
  bucket = aws_s3_bucket.s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}