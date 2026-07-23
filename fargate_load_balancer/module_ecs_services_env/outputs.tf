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