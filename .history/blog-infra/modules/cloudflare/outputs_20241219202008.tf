output "zone_id" {
  description = "The Cloudflare Zone ID for the domain."
  value       = data.cloudflare_zone.blog_zone.id # Correct reference to the data block
}

output "validation_details" {
  value = [{
    resource_record_name  = cloudflare_record.acm_validation.name
    resource_record_type  = cloudflare_record.acm_validation.type
    resource_record_value = cloudflare_record.acm_validation.content
  }]
}
