terraform {
  backend "remote" {
    organization = "DZarpelon_Blog"
    workspaces {
      name = "blog"
    }

  }
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~>0.100"
    }
  }
}

variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

module "cloudflare" {
  source            = "./modules/cloudflare"
  hcp_client_id     = var.hcp_client_id
  hcp_client_secret = var.hcp_client_secret
}

module "aws_s3_bucket" {
  source            = "./modules/s3_bucket"
  hcp_client_id     = var.hcp_client_id
  hcp_client_secret = var.hcp_client_secret
}

