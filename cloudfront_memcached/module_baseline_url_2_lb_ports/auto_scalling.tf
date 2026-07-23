resource "aws_appautoscaling_target" "ServiceAutoScalingTarget" {
  count              = var.autoScale_resource_usage == true || var.autoScale_daytime == true ? 1 : 0
  min_capacity       = var.desired_min
  max_capacity       = var.desired_max
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.ecs_service.name}" # service/(clusterName)/(serviceName)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

}


# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up-scale" {
  count              = var.autoScale_resource_usage ? 1 : 0
  name               = "${var.service_name}ScaleUp"
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = [aws_appautoscaling_target.ServiceAutoScalingTarget]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down-auto" {
  count              = var.autoScale_resource_usage ? 1 : 0
  name               = "${var.service_name}ScaleDown"
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = [aws_appautoscaling_target.ServiceAutoScalingTarget]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  count               = var.autoScale_resource_usage ? 1 : 0
  alarm_name          = "${var.service_name}_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.ecs_service.name
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.service_name}-alarm-up"
      )
    },
    var.tags,
  )
  alarm_actions = [aws_appautoscaling_policy.up-scale[0].arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  count               = var.autoScale_resource_usage ? 1 : 0
  alarm_name          = "${var.service_name}_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "35"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.ecs_service.name
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.service_name}-alarm-down"
      )
    },
    var.tags,
  )
  alarm_actions = [aws_appautoscaling_policy.down-auto[0].arn]

}









# Scale up weekdays at beginning of day
resource "aws_appautoscaling_scheduled_action" "WeekdayScaleUp" {
  count              = var.autoScale_daytime ? 1 : 0
  name               = "${var.service_name}ScaleUp"
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  schedule           = "cron(0 8 ? * MON-FRI *)" #Every weekday at 8 a.m. PST
  timezone           = "America/Los_Angeles"

  scalable_target_action {
    min_capacity = var.desired_max
    max_capacity = var.desired_max
  }
}

# Scale down weekdays at end of day
resource "aws_appautoscaling_scheduled_action" "WeekdayScaleDown" {
  count              = var.autoScale_daytime ? 1 : 0
  name               = "${var.service_name}ScaleDown"
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  schedule           = "cron(0 20 ? * MON-FRI *)" #Every weekday at 8 p.m. PST
  timezone           = "America/Los_Angeles"

  scalable_target_action {
    min_capacity = var.desired_min
    max_capacity = var.desired_min
  }
}

# Scale to 0 to refresh fleet
resource "aws_appautoscaling_scheduled_action" "Refresh" {
  count              = var.autoScale_daytime ? 1 : 0
  name               = "${var.service_name}Refresh"
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  schedule           = "cron(0 0 * * ? *)" #Every day at midnight PST
  timezone           = "America/Los_Angeles"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}

# Scale down to minimum after rebuild
resource "aws_appautoscaling_scheduled_action" "RefreshBackUp" {
  count              = var.autoScale_daytime ? 1 : 0
  name               = "${var.service_name}RefreshBackUp"
  service_namespace  = aws_appautoscaling_target.ServiceAutoScalingTarget[0].service_namespace
  resource_id        = aws_appautoscaling_target.ServiceAutoScalingTarget[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ServiceAutoScalingTarget[0].scalable_dimension
  schedule           = "cron(5 0 * * ? *)" #Every day at 12:05a PST
  timezone           = "America/Los_Angeles"

  scalable_target_action {
    min_capacity = var.desired_min
    max_capacity = var.desired_min
  }
}