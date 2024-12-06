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

resource "aws_s3_bucket" "dzarpelon_blog_bucket" {
  bucket = "dzarpelon_blog_bucket"
  object_lock_enabled = true
  }
