resource "aws_lb_listener_rule" "host_based_routing" {
  for_each = local.rule_hosted_based
  
  listener_arn = var.listener_arn
  priority     = each.value["priority"]

  action {
    type             = each.value["type"]
    target_group_arn = each.value["target_group_arn"]
  }

  condition {
    host_header {
      #values = ["smy-service.*.terraform.io"]
      values = each.value["host"]
    }
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-sg-custom"
      )
    },
    var.tags,
  )
}