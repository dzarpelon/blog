variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

variable "origin_bucket" {
  description = "The name of the S3 bucket serving as the CloudFront origin."
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate to use for HTTPS."
  type        = string
}

variable "domain_name" {
  description = "The custom domain name for the CloudFront distribution."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudFront distribution."
  type        = map(string)
  default     = {}
}