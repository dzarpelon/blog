terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.100"
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

resource "hcp_project" "blog" {
  name        = "blog"
  description = "My blog project"
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

module "acm" {
  source      = "./modules/acm"
  domain_name = "blog.dzarpelon.com"
}
