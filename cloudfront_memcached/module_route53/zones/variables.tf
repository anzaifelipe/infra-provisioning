variable "domain_name" {
  description = "Set a name for domain"
  type        = string
}

variable "prefix_name" {
  description = "set the prefix name"
  type        = string
}

variable "vpc_id" {
  description = "set the VPC ID"
  type        = string
}

variable "is_public" {
  description = "set true or false to create only internal zone"
  type        = bool
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}