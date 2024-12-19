variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name to use with the CloudFront distribution."
  type        = string
}