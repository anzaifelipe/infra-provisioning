resource "aws_elasticache_cluster" "memcached" {
  count                = var.create_memcached_cluster ? 1 : 0

  cluster_id           = var.cluster_name
  engine               = "memcached"
  engine_version       = var.engine_version
  node_type            = var.instance_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  tags                 = var.tags
  security_group_ids   = var.security_group_ids
  subnet_group_name    = aws_elasticache_subnet_group.this.name
}