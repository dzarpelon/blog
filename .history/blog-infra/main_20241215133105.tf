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

provider "hcp" {
  client_id     = data.hcp_vault_secrets_secret.hcp_credentials.data["client_id"]
  client_secret = data.hcp_vault_secrets_secret.hcp_credentials.data["client_secret"]
}
data "hcp_vault_secrets_secret" "hcp_credentials" {
  app_name   = "HCP"
  secret_name = "credentials"
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
