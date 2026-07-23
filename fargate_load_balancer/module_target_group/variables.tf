variable "prefix_name" {
  description = "name used in tags"
  type        = string
}

variable "port" {
    description = "port number"
    type        = number
}

variable "protocol" {
    description = "HTTP, HTTPS, TCP, TLS, UDP, TCP_UDP, GENEVE"
    type        = string
}

variable "vpc_id" {
  description = "CiDR for VPC"
  type        = string
}

variable "health_check_port" {
  description = "Use traffic-port as default or set a diferent port number for health check"
  default     = "traffic-port"
}

variable "target_type" {
  description = "instance, ip, lambda, alb"
  type        = string
}

variable "protocol_healthCheck" {
    description = "HTTP or HTTPS"
    type        = string  
}

variable "health_path" {
  description = "Health check path for ecs container"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}