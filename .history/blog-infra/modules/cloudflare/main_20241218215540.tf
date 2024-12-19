terraform {
  required_providers {
    hcp = {
      source = "hashicorp/hcp"
      version = "~>0.100"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~>4.48"
    }
     aws = {
      source = "hashicorp/aws"
      version = "~>5.81"
    }
  }
}
## Fetch Secrets from HCP Vault
data "hcp_vault_secrets_app" "cloudflare" {
  app_name   = "Cloudflare"
}

# set aws region for ACM certificate generation for Cloudfront:
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"  # ACM certificates for CloudFront must be in us-east-1
}
#Cloudflare provider block

# Set Cloudflare token
provider "cloudflare" {
  api_token = data.hcp_vault_secrets_app.cloudflare.secrets["zone_edit"]
}

# Query the Cloudflare zone dynamically using the domain name
data "cloudflare_zone" "blog_zone" {
  name = var.domain_name
}
resource "cloudflare_record" "blog_cloudfront" {
  zone_id = data.cloudflare_zone.blog_zone.id
  name    = "blog"  # Subdomain for your blog
  type    = "CNAME"
  content = var.cloudfront_distribution_domain_name  # Replace this with the actual domain
  ttl     = 300
  proxied = false    # Set to true if you want to use Cloudflare's proxy
}

#  validation details and create DNS records
resource "cloudflare_record" "acm_validation" {
  zone_id = data.cloudflare_zone.blog_zone.id
  name    = var.validation_details[0].resource_record_name
  type    = var.validation_details[0].resource_record_type
  content = var.validation_details[0].resource_record_value
  ttl     = 300
}
