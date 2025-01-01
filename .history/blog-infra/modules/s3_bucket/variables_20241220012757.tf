variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

variable "oai_arn" {
  description = "The ARN of the CloudFront Origin Access Identity"
  type        = string
}