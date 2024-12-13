# Set Terraform configuration block to use required providers 
terraform {
  required_providers {
    hcp = {
      source = "hashicorp/hcp"
      version = "~>0.100"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~>5.0"
    }
  }
}
# HashiCorp Cloud Platform provider block
## Fetch Secrets from HCP Vault
data "hcp_vault_secrets_secret" "cloudflare_zone_edit_secret" {
  app_name   = "Cloudflare"
  secret_name = "zone_edit"
}
data "hcp_vault_secrets_secret" "cloudflare_zone_id_secret" {
  app_name   = "Cloudflare"
  secret_name = "zoneID"
}

#Cloudflare provider block

# Set Cloudflare token
provider "cloudflare" {
  api_token = data.hcp_vault_secrets_secret.cloudflare_zone_edit_secret.value
}

# Create a Cloudflare DNS record
resource "cloudflare_record" "example" {
  zone_id = data.hcp_vault_secrets_secret.cloudflare_zone_id_secret.value
  name    = "test"
  content = "192.0.2.2"
  type    = "A"
  ttl     = 3600
}
# outputs block
output "cloudflare_zone_edit_secret" {
  value = data.hcp_vault_secrets_secret.cloudflare_zone_edit_secret.value
  sensitive = true
}

output "cloudflare_zone_id_secret" {
  value = data.hcp_vault_secrets_secret.cloudflare_zone_id_secret.value
  sensitive = true
}
