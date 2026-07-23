variable "prefix_name" {
  description = "Set prefix name to resources"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "use_ssl" {
  description = "Define true if certificarte is necessary"
  type        = bool
}

variable "redirect_to_https" {
  description = "Used to create a lister in ALB to redirect port 80 to port 443"
  type        = bool
}

variable "forward_to_https" {
  description = "Used to create a lister in ALB to forward port 80 to port 443"
  type        = bool
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 443
}
# Module variables

variable "listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTPS"
}

variable "load_balancer_arn" {
  description = "Set the ARN of load balancer"
  type        = string
}

variable "target_group_arn" {
  description = "Set the ARN of target group created in ALB module"
  type        = string
}

variable "listener_policy" {
  description = "Listener policy"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "ARN of SSL certificate"
  type        = string
  default     = "value"
}   