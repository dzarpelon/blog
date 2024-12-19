terraform {
    required_providers {
      hcp = {
        source = "hashicorp/hcp"
        version = "~>0.100"
      }
      aws= {
        source = "hashicorp/aws"
        version = "~>5.81"
      }
    }
}

#set certificate creation at us-east -1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
# Fetch Secrets from HCP Vault

data "hcp_vault_secrets_app" "aws_free_tier" {
    app_name   = "AWSfreeTier"
}

provider "aws" {
    region = "eu-central-1"
    access_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_access_key_id"]
    secret_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_secret_access_key"]
}

# This resource creates an ACM certificate for the specified domain using DNS validation.
resource "aws_acm_certificate" "this" {
  provider = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  tags                      = var.tags

  # The lifecycle block ensures that the certificate is created before an existing one is destroyed, minimizing downtime.
  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Records (handled by a separate Cloudflare module)
# This data block retrieves the details of the most recent ACM certificate in the 'PENDING_VALIDATION' state for the domain.
data "aws_acm_certificate" "cert" {
  domain                 = aws_acm_certificate.this.domain_name
  statuses               = ["ISSUED","PENDING_VALIDATION"]
  most_recent            = true
}