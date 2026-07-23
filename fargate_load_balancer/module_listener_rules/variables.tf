variable rule_hosted_based {
    description = "Map of DNS alias records"
    type = map
    default = {}
}

variable "listener_arn" {
  description = "ARN of listener in LoadBalancer"
  type        = string
}

variable "prefix_name" {
  description = "Name to use to indentify resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}