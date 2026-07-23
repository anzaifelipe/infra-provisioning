variable "prefix_name" {
  description = "name used in tags and resources"
  type        = string
}


variable "vpc_id" {
  description = "ID for the vpc created"
  type        = string
}

variable "security_group_name" {
  description = "Name of Security Group"
  type        = string
}

variable "security_group_description" {
  description = "Description of Security Group"
  type        = string
  default     = "Default description of Security Group"
}

variable "security_group_rules" {
  description = "Map of rules for Security Group"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}