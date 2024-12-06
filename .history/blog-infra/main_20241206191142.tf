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

resource "hcp_organization" "HCP_Organization" {
  name = "DZarpelon_Blog"
}

resource "aws_s3_bucket" "dzarpelon_blog_bucket" {
  bucket = "dzarpelon_blog_bucket"
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}