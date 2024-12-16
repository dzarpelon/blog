# Output for the ACM certificate's Amazon Resource Name (ARN).
# This can be used to reference the certificate in other modules or resources.
output "certificate_arn" {
  description = "The ARN of the ACM certificate."
  value       = aws_acm_certificate.this.arn
}

# Output for the DNS validation details required for certificate validation.
# This is useful for debugging or passing the details to another module for DNS record creation.
output "validation_details" {
  description = "The DNS validation details for the ACM certificate."
  value       = aws_acm_certificate.this.domain_validation_options
}