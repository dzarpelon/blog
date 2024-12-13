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

# Fetch Secrets from HCP Vault

data "hcp_vault_secrets_app" "aws_blog" {
    app_name   = "aws_blog"
}