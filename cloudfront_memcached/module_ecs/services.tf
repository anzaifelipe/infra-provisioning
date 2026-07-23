# Service definition, auto heals if task shuts down
resource "aws_ecs_service" "ecs_service" {
  name             = "${var.ecs_name}Service"
  cluster          = aws_ecs_cluster.fargate_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count    = var.autoscale_task_weekday_scale_down
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets          = var.is_public == true ? var.public_subnets : var.private_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = var.is_public == true ? true : false
  }

  # Ignored desired count changes live, permitting schedulers to update this value without terraform reverting
  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.minio-target-group.arn
    container_name   = "minio-s3"
    container_port   = var.app_port
  }
  
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.ecs_name}-service"
      )
    },
    var.tags,
  )
}