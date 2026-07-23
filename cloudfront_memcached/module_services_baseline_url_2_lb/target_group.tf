resource "aws_lb_target_group" "target_group" {
  name        = "${var.tg_name}"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 60
    matcher             = "200"
    path                = var.health_path != "" ? var.health_path : "/"
    port                = var.health_check_port
    protocol            = var.protocol_healthCheck
    timeout             = 30
    unhealthy_threshold = 2
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-tg"
      )
    },
    var.tags,
  )
}