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

# resource "aws_s3_bucket" "dzarpelon_blog_bucket" {
#  bucket = "dzarpelon-blog-bucket"
#  object_lock_enabled = true
#  }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}