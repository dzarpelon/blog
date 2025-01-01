output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}