# Cluster is compute that service will run on
resource "aws_ecs_cluster" "fargate_cluster" {
  name = "${var.ecs_name}-Cluster"

  setting {
    name  = "containerInsights"
    value = var.insights
 }

  tags = merge(
    {
      "Name" = format(
        "${var.ecs_name}-cluster"
      )
    },
    var.tags,
  )
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.fargate_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}