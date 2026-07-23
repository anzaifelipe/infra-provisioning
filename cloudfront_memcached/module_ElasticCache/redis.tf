resource "aws_elasticache_cluster" "redis" {
  count                = 0
  #count                = var.create_redis_cluster ? 1 : 0

  cluster_id           = var.cluster_name
  engine               = "redis"
  node_type            = var.instance_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.redis7"
  port                 = 6379
  tags                 = var.tags
  security_group_ids   = var.security_group_ids
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}