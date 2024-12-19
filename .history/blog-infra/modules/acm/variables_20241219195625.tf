variable "hcp_client_id" {
  description = "The client ID for HCP"
  type        = string
}

variable "hcp_client_secret" {
  description = "The client secret for HCP"
  type        = string
}







# Variable for specifying the primary domain name for the ACM certificate.
# This is the main domain that will be secured by the certificate.
variable "domain_name" {
  description = "The primary domain name for the ACM certificate."
  type        = string
}

# Variable for providing a list of additional domain names for the ACM certificate.
# These domains will also be secured by the same certificate.
variable "subject_alternative_names" {
  description = "A list of additional domain names for the ACM certificate."
  type        = list(string)
  default     = []
}

# Variable for defining tags to apply to the ACM certificate.
# Tags help in organizing and managing AWS resources efficiently.
variable "tags" {
  description = "Tags to apply to the ACM certificate."
  type        = map(string)
  default     = {}
}

# Variable for specifying the Cloudflare Zone ID required for DNS validation.
# Note: DNS records for validation will be created by another module.
variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for DNS validation. Records will be handled by another module."
  type        = string
}

variable "validation_details" {
  description = "Validation details for DNS records (optional for ACM validation)"
  type        = list(object({
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  default     = []  # Optional, allows for empty values
}