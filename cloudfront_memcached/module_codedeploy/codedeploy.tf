# create a CodeDeploy application
resource "aws_codedeploy_app" "this" {
  compute_platform = "Server"
  name             = var.name
  tags = merge(
    {
      "Name" = format(
        "${var.name}-app"
      )
    },
    var.tags,
  )
}

# create a deployment group
resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = var.group_name
  service_role_arn      = aws_iam_role.this.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.server_name
    }
  }


  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = var.roll_back
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
  tags = merge(
    {
      "Name" = format(
        "${var.name}-deploy-group"
      )
    },
    var.tags,
  )
}