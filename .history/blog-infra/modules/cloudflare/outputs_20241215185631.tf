output "zone_id" {
  description = "The Cloudflare Zone ID for the domain."
  value       = cloudflare_zone.blog.zone_id
}