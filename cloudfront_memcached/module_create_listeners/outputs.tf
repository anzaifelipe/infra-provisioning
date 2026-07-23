output "alb_listener_arn" {
  description = "ARN of Application Load Balancer Listener"
  value       = aws_lb_listener.custom_listener.arn
}

output "alb_listener_arn_forward" {
  description = "ARN of Application Load Balancer Listener"
  value       = try(aws_lb_listener.forward_https[0].arn, "")
}

output "alb_listener_default" {
  description = "ARN of Application Load Balancer Listener"
  value       = try(aws_lb_listener.default_listener[0].arn, "")
}
