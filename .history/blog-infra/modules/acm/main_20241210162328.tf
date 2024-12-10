resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "validation_options" {
  value = aws_acm_certificate.cert.domain_validation_options
}