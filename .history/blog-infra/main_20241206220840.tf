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
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "blog-dzarpelon"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

resource "aws_cloudfront_distribution" "dzarpelon_blog_cdn" {
  origin {
    domain_name = module.s3_bucket.bucket_regional_domain_name
    origin_id   = "S3-blog-dzarpelon"

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
    target_origin_id = "S3-blog-dzarpelon"

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

  price_class = "PriceClass_100"  // Use the lowest price class to minimize costs

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