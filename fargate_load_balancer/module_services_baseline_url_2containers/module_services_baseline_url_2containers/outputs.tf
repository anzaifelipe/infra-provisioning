output "target_group_arn" {
  description = "ARN of target group"
  value = aws_lb_target_group.target_group.arn
}

output "routing" {
  description = "ID of the ECS Cluster"
  value       = var.rule_hosted_based
}

output "zone_id" {
    value = var.zone_id
    description = "ID of Route53 zone"
}

output "dns_records" {
    value = var.dns_record_items
    description = "DNS records"
}

output "dns_alias_records" {
    value = var.dns_alias_records
    description = "DNS alias records"
}

output "dns_weighted_records" {
    value = var.dns_weighted_record_items
    description = "DNS Weighted records"
}

output "service_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_service.ecs_service.id
}

output "service_name" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_service.ecs_service.name
}

output service_discovery_service_arn {
  description = "The Service Discovery Service ARN."
  value       = coalescelist(aws_service_discovery_service.sds.*.arn, [null])[0]
}

#output namespace_id {
#  description = "The Service Discovery Namespace ID."
#  value       = coalescelist(aws_service_discovery_service.sds.*.id, [null])[0]
#}

output namespace_id {
  description = "The Service Discovery Namespace ID."
  value       = coalescelist(aws_service_discovery_private_dns_namespace.namespace.*.id, [null])[0]
}