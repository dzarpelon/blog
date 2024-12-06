terraform {
  
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

resource "hcp_organization" "HCP_Organization" {
  name = "DZarpelon_Blog"
}