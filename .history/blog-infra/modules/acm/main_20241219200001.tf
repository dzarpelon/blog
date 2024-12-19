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
provider "aws" {
    region = "eu-central-1"
    access_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_access_key_id"]
    secret_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_secret_access_key"]
}
#set certificate creation at us-east -1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  access_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_access_key_id"]
  secret_key = data.hcp_vault_secrets_app.aws_free_tier.secrets["aws_secret_access_key"]
}

data "hcp_vault_secrets_app" "aws_free_tier" {
  app_name = "AWSfreeTier"
}

resource "aws_acm_certificate" "this" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  tags = var.tags
}

resource "aws_acm_certificate_validation" "this" {
  provider          = aws.us_east_1
  certificate_arn   = aws_acm_certificate.this.arn
  validation_record_fqdns = [
    for record in var.validation_details : record.resource_record_value]
  
}