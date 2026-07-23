# Service definition, auto heals if task shuts down
resource "aws_ecs_service" "ecs_service" {
  name             = "${var.service_name}"
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  enable_execute_command = var.enable_execute_command
  platform_version = "LATEST"
  network_configuration {
    subnets          = var.is_public == true ? var.public_subnets : var.private_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = var.assign_public_ip
  }

  # Ignored desired count changes live, permitting schedulers to update this value without terraform reverting
  #lifecycle {
  #  ignore_changes = [desired_count]
  #}

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  load_balancer {
    target_group_arn = var.second_tg_arn
    container_name   = var.container_name
    container_port   = var.second_container_port
  }

    # When Service Discovery is enabled
  dynamic service_registries {
    for_each = aws_service_discovery_service.sds

    # Setting port is not supported whne using "host" or "bridge" network mode.
    content {
      registry_arn   = service_registries.value.arn
      port           = var.service_discovery_container_port
      container_name = var.service_discovery_container_name
      container_port = var.service_discovery_container_port
    }
  }

  
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.service_name}"
      )
    },
    var.tags,
  )
}