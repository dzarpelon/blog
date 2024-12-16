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


# Create a Cloudflare DNS record for the Cloudfront 
#resource "cloudflare_record" "blog" {
#  zone_id = data.cloudflare_zone.blog_zone.id
#  name    = "blog"
#  content = "192.0.2.2"
#  type    = "A"
#  ttl     = 3600
# }

# Loop through validation details and create DNS records
resource "cloudflare_record" "acm_validation" {
  for_each = { for v in var.validation_details : v.resource_record_name => v }

  zone_id = data.cloudflare_zone.blog_zone.id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  value   = each.value.resource_record_value
  ttl     = 300
}
