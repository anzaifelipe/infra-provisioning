variable "vpc_cidr" {
  description = "CiDR for VPC"
  type        = string
}

variable "prefix_name" {
  description = "name used in tags"
  type        = string
}

variable "enable_external_access" {
  description = "set true or false if need external access in vpc"
  type        = bool
}

variable "enbale_private_to_internet" {
  description = "set true or false if private subnet has access to internet"
  type        = bool
}

variable "sufix_name" {
  description = "sufix used in tags and resource names"
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}