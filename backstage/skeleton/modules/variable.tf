variable "prefix_name" {
  type        = string
  description = "Fixed name at start of any reource"
}

variable "instance_type" {
  type        = string
  description = "Amazon instance type using t3a.small is enough"
}

variable "domain" {
  type        = string
  description = "domain name"
}

variable "passdb" {
  type        = string
  description = "password for database"
}

variable "subnet" {
  type        = string
  description = "subnet id"
}

variable "volume_size" {
  type        = number
  description = "instance volume size in GB"
}

variable "key_pair" {
  type        = string
  description = "key pair name"
}

variable "tags" {
  type        = map(string)
  description = "tags for resources" 
  default     = {}
}

#######----
#DSN records
#######----

variable dns_record_items {
    description = "Map of DNS records"
    type = map
    default = {}
}

variable dns_alias_records {
    description = "Map of DNS alias records"
    type = map
    default = {}
}

variable dns_weighted_record_items {
    description = "Map of DNS Weighted records"
    type = map
    default = {}
}


variable zone_id {
    description = "ID of Route53 zone"
    type = string
}

#######----
#SG
#######----

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