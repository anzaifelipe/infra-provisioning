# Cluster is compute that service will run on
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "${var.ecs_name}Cluster"
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.ecs_name}-cluster"
      )
    },
    var.tags,
  )
}