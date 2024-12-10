variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
  default     = "blog.dzarpelon.com"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}