output "zone_id" {
  description = "The Cloudflare Zone ID for the domain."
  value       = data.cloudflare_zone.blog_zone.id # Correct reference to the data block
}

output "validation_details" {
  description = "The DNS validation details for the ACM certificate."
  value = [
    for record in cloudflare_record.acm_validation :
    {
      resource_record_name  = record.name
      resource_record_type  = record.type
      resource_record_value = record.value
    }
  ]
}
