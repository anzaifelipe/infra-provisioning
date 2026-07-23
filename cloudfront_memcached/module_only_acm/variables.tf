# Module variables
variable "prefix_name" {
  description = "Set prefix name to resources"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "validation_method" {
  description = "Validation method of certificate"
  default     = "DNS"
  type        = string
}

#variable "zone_id" {
#  description = "ID of Route53 zone"
#  type        = string
#}

#variable alternative_domains {
#    description = "Alternative domain names"
#    default = []
#    type = list
#}