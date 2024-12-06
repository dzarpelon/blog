terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

data "hcp_organization" "HCP_Organization" {

}

# Create an S3 bucket with object lock enabled
resource "aws_s3_bucket" "dzarpelon_blog_bucket" {
  bucket = "dzarpelon-blog-bucket"
  object_lock_enabled = true
  }
# create a cloudfront for the bucket ssl and cdn
resource "aws_cloudfront_distribution" "dzarpelon_blog_cdn" {
  origin {
    domain_name = aws_s3_bucket.dzarpelon_blog_bucket.bucket_regional_domain_name
    origin_id   = "S3-dzarpelon-blog-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.dzarpelon_blog_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for dzarpelon blog"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-dzarpelon-blog-bucket"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method              = "sni-only"
    minimum_protocol_version        = "TLSv1.2_2019"
  }
}

resource "aws_cloudfront_origin_access_identity" "dzarpelon_blog_identity" {
  comment = "Origin Access Identity for dzarpelon blog"
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for SSL"
  type        = string
}
