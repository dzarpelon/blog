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

# CloudFront domain name (optional placeholder for initial apply).
variable "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name. If unknown, a placeholder will be used."
  type        = string
  default     = "placeholder.cloudfront.net"
}

# Logic to handle placeholder-based Cloudflare DNS record creation
resource "cloudflare_record" "cloudfront" {
  zone_id = data.cloudflare_zone.blog_zone.id
  name    = "blog"
  type    = "CNAME"
  value   = coalesce(var.cloudfront_domain_name, "placeholder.cloudfront.net")
  ttl     = 300
}
