output "certificate_arn" {
  description = "The ARN of the ACM certificate from the module."
  value       = module.acm.certificate_arn
}

output "validation_details" {
  description = "The DNS validation details from the ACM module."
  value       = module.acm.validation_details
}
