/*#######
Criando o TargetGroup do LB
#######*/
resource "aws_lb_target_group" "target-group" {
  name        = "${var.prefix_name}-tg"
  port        = "${var.target_port}"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-tg"
      )
    },
    var.tags,
  )
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = var.health_path != "" ? var.health_path : "/"
    port                = var.health_check_port
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 2
  }
}