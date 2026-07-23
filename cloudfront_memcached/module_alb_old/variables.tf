variable "name" {
  description = "Name of security group"
  type        = string
}

variable "prefix_name" {
  description = "Set prefix name to resources"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID for the vpc created"
  type        = string
}

variable "internal_flag" {
  description = "Boolean flag of internal/external switch"
  type        = bool
  default     = "false"
}

variable "health_check_port" {
  description = "set traffic-port as default, define a port number instead"
  default     = "traffic-port"
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

variable "security_group_id" {
  description = "List of security groups"
  type        = list(any)
  default     = []
}

variable "subnets" {
  description = "List of subnets"
  type        = list(any)
  default     = []
}

variable "enable_deletion_protection_flag" {
  description = "Boolean flag of delete protection flag"
  type        = bool
  default     = "false"
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 443
}

variable "target_port" {
  description = "target port"
  type        = number
  default     = 80
}

variable "health_path" {
  description = "Health check path for ecs container"
  type        = string
}

# Module variables

variable "listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTPS"
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