variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
  default = "TF_VAR_hcp_client_id"
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}