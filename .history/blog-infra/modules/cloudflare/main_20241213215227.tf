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
  }
}
## Fetch Secrets from HCP Vault
data "hcp_vault_secrets_app" "cloudflare" {
  app_name   = "Cloudflare"
}
#Cloudflare provider block

# Set Cloudflare token
provider "cloudflare" {
  api_token = data.hcp_vault_secrets_app.cloudflare.secrets["zone_edit"]
}

# Create a Cloudflare DNS record for the Cloudfront 
resource "cloudflare_record" "example" {
  zone_id = data.hcp_vault_secrets_app.cloudflare.secrets["zoneID"]
  name    = "test"
  content = "192.0.2.2"
  type    = "A"
  ttl     = 3600
}
