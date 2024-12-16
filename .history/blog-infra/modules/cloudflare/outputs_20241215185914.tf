output "zone_id" {
  description = "The Cloudflare Zone ID for the domain."
  value       = data.cloudflare_zone.blog_zone.id # Correct reference to the data block
}