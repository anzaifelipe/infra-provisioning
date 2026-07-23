resource "aws_elasticache_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.is_public == true ? var.subnets_public : var.subnets_private
}