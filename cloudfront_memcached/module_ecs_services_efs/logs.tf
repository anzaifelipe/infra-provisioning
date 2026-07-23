/*#######======================================================================================================
------------------Creating Cloudwatch logs for ECS
======================================================================================================#######*/
# Cloudwatch to store logs
resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name = "${var.service_name}LogGroup"

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.service_name}-cluster"
      )
    },
    var.tags,
  )
}

resource "aws_cloudwatch_log_stream" "CloudWatchLogStream" {
  name           = "${var.service_name}LogStream"
  log_group_name = aws_cloudwatch_log_group.CloudWatchLogGroup.name
}