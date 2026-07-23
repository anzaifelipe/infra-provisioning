/*#######======================================================================================================
------------------Creating Cloudwatch logs for ECS
======================================================================================================#######*/
# Cloudwatch to store logs
resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name = "${var.ecs_name}LogGroup"
  retention_in_days = var.retention_in_days
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.ecs_name}-cluster"
      )
    },
    var.tags,
  )
}

resource "aws_cloudwatch_log_stream" "CloudWatchLogStream" {
  name           = "${var.ecs_name}LogStream"
  log_group_name = aws_cloudwatch_log_group.CloudWatchLogGroup.name
}