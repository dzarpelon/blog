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

variable "origin_bucket" {
  description = "The name of the S3 bucket to use as the origin for the CloudFront distribution."
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate to use with the CloudFront distribution."
  type        = string
}