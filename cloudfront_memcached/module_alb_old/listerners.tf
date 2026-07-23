#resource "aws_lb_listener" "default_listener" {
#  load_balancer_arn = aws_lb.this.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.target-group.arn
#  }
#
#  tags = merge(
#    {
#      "Name" = format(
#        "${var.prefix_name}-listener-default"
#      )
#    },
#    var.tags,
#  )
#}

resource "aws_lb_listener" "default_listener" {
  count = var.redirect_to_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-listener-default"
      )
    },
    var.tags,
  )
}

resource "aws_lb_listener" "custom_listener" {

  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = var.use_ssl ? var.listener_policy : null
  certificate_arn   = var.use_ssl ? var.certificate_arn : null

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-listener-custom"
      )
    },
    var.tags,
  )

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_lb_listener" "forward_https" {
  count = var.forward_to_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.forward_to_https ? var.listener_policy : null
  certificate_arn   = var.forward_to_https ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-forward-https"
      )
    },
    var.tags,
  )
}