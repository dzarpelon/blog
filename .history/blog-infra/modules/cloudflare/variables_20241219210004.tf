variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}

variable "domain_name" {
  description = "The domain name managed by Cloudflare."
  type        = string
}

# Variable for storing ACM validation details for DNS record creation.
# This includes domain name, record name, record type, and record value.
variable "validation_details" {
  description = "ACM validation details for creating DNS records."
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}
variable "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}