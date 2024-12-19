variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string

}
variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

# Primary domain name for the ACM certificate
variable "domain_name" {
  description = "The primary domain name for the ACM certificate."
  type        = string
}

# List of additional domain names for the ACM certificate
variable "subject_alternative_names" {
  description = "A list of additional domain names for the ACM certificate."
  type        = list(string)
  default     = [] # Optional default if no alternative names are provided
}

# Tags for the ACM certificate
variable "tags" {
  description = "Tags to apply to the ACM certificate."
  type        = map(string)
  default     = {} # Optional default for no tags
}

variable "cloudflare_api_token" {
  description = "The API token for Cloudflare."
  type        = string
}