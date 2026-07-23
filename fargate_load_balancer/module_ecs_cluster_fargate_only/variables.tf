# Naming variables
variable "ecs_name" {
  description = "Name primitive to use for all resources created"
}

variable "prefix_name" {
  description = "Set prefix name to resources"
}

variable "insights" {
  description = "set enabled or disabled to capture metrics in cloudwatch for cpu, memory, disk and network"
  default     = "disabled" 
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}