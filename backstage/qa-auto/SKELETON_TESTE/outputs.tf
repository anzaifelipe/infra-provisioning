/*#######################
SECURITY GROUP SESSION
########################*/

output "rds_security_group_name" {
  description = "Name of Security Group"
  value       = module.sg_rds.security_group_name
}


output "private_security_group_name" {
  description = "Name of Security Group"
  value       = module.sg_private.security_group_name
}


output "public_security_group_name" {
  description = "Name of Security Group"
  value       = module.sg_public.security_group_name
}

/*#######################
ACM SESSION
########################*/

output "certificate_arn" {
  description = "ARN of certificate"
  value       = module.certificate.domain_name
}

/*#######################
ALB SESSION
########################*/

output "private_alb_dns_name" {
  description = "DNS name of ALB"
  value       = module.alb_private.alb_dns_name
}

output "private_alb_name" {
  description = "Name of load balancer"
  value       = module.alb_private.alb_name
}

output "public_alb_dns_name" {
  description = "DNS name of ALB"
  value       = module.alb_public.alb_dns_name
}

output "public_alb_name" {
  description = "Name of load balancer"
  value       = module.alb_public.alb_name
}

/*#######################
RDS SESSION
########################*/

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_endpoint
}

/*#######################
ECS CLUSTER SESSION
########################*/

output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = module.ecs_cluster.ecs_cluster_id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_name
}

/*#######################
ZONE INTERNAL SESSION
########################*/

output "domain_name_private" {
  description = "Domain name of Route53 Zone Private"
  value       = module.zone_internal.domain_name_private
}

output "name_private" {
  description = "Name of Route53 Zone Private"
  value       = module.zone_internal.name_private
}

/*#######################
DNS SESSION
########################*/

output "rds_dns_records" {
    value = module.dns_rds.dns_records
    description = "DNS records"
}

/*#######################
EFS SESSION
########################*/

output "efs_arn" {
  description = "EFS Identify"
  value       = module.efs.efs_arn
}

/*#######################
SQS SESSION
########################*/

output "queue_name" {
  description = "The name of the SQS queue"
  value       = module.sqs.queue_name
}

/*#######################
ECS SESSION
########################*/

output "filemanagement_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_filemanagement.service_name
}

output "cms_api_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_api.service_name
}

output "cms_auth_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_auth.service_name
}

output "cms_frontend_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_frontend.service_name
}

output "cms_concurrency_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_concurrency.service_name
}

output "cms_edithistory_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_edithistory.service_name
}

output "cms_mailer_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_mailer.service_name
}

output "cms_mongodb_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_mongodb.service_name
}

output "cms_permission_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_cms_permission.service_name
}

output "cms_exporter_service_name" {
  description = "ARN of the ECS Cluster"
  value       = module.ecs_tsv_exporter.service_name
}