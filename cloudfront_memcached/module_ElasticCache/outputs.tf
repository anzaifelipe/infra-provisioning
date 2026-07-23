output "group_name" {
  description = "The Name of the ElastiCache Subnet Group."
  value       = aws_elasticache_subnet_group.this.name
}

output "subnet_ids" {
  description = "The Subnet IDs of the ElastiCache Subnet Group."
  value       = aws_elasticache_subnet_group.this.subnet_ids
}

output "cluster_memcached_arn" {
  description = "The ARN of the created ElastiCache Cluster."
  value       =  try(aws_elasticache_cluster.memcached[0].arn, "")
}

output "cluster_redis_arn" {
  description = "The ARN of the created ElastiCache Cluster."
  value       =  try(aws_elasticache_cluster.redis[0].arn, "")
}

output "memcached_endpoint" {
  description = "The Configuration Endpoint of the created ElastiCache Cluster."
  value       =  try(aws_elasticache_cluster.memcached[0].configuration_endpoint, "")
}

output "redis_endpoint" {
  description = "The Configuration Endpoint of the created ElastiCache Cluster."
  value       =  try(aws_elasticache_cluster.redis[0].configuration_endpoint, "")
}