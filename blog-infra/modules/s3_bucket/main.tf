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

  force_destroy = true
}

# 2. Temporarily disable block public access settings
resource "aws_s3_bucket_public_access_block" "disable_block" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 3. Create an S3 bucket policy
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

  depends_on = [aws_s3_bucket_public_access_block.disable_block]
}

# 4. Re-enable block public access settings
resource "aws_s3_bucket_public_access_block" "enable_block" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket_policy.s3-bucket-policy]
}

# 5. Create S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "blog-bucket-ownership-controls" {
  bucket = aws_s3_bucket.s3-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 6. Create a lifecycle policy to delete versioned objects and delete markers
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3-bucket.id

  rule {
    id     = "Delete old versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}