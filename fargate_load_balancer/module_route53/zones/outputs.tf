output "zone_id" {
  description = "ID of Route53 Zone"
  value       = try(aws_route53_zone.hosted_zone[0].id, "")
}

output "domain_name" {
  description = "Domain name of Route53 Zone"
  value       = try(aws_route53_zone.hosted_zone[0].zone_id, "")
}

output "zone_id_private" {
  description = "ID of Route53 Zone Private"
  value       = try(aws_route53_zone.hosted_zone_private[0].id, "")
}

output "domain_name_private" {
  description = "Domain name of Route53 Zone Private"
  value       = try(aws_route53_zone.hosted_zone_private[0].zone_id, "")
}