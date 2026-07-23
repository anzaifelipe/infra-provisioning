# Naming variables
variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "create_memcached_cluster" {
  description = "Whether to create a memcached cluster"
  type        = bool
  default     = false
}

variable "create_redis_cluster" {
  description = "Whether to create a memcached cluster"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "The instance class used"
  default     = "cache.t3.small"
}

variable "engine_version" {
  description = "Version number of the cache engine to be used"
}

variable "num_cache_nodes" {
  description = "The number of cache nodes in the cluster"
  default     = 2
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

#### SUBNET GROUP VARS 
variable "subnet_group_name" {
  description = "The name of the subnet group"
  type        = string
}

variable "is_public" {
  description = "Whether the subnet group is public"
  type        = bool
  default     = true
}

variable "subnets_public" {
  description = "A list of public subnet IDs"
  type        = list(string)
}

variable "subnets_private" {
  description = "A list of private subnet IDs"
  type        = list(string)
}

#### GENERAL

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
