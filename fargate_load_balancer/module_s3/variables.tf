variable "prefix_name" {
  description = "name used in tags"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Set a name for bucket"
  type        = string
}

variable "block_public_acls" {
  description = "Block public access to buckets and objects granted through new access control lists (ACLs)"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public access to buckets and objects granted through new public bucket or access point policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Block public access to buckets and objects granted through any access control lists (ACLs)"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Block public and cross-account access to buckets and objects through any public bucket or access point policies"
  type        = bool
  default     = true
}

variable "enable_acl" {
  description = "Set true or false to enable ACL list"
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "enable_public_bucket" {
  description = "value to enable public bucket"
  type        = bool
  default     = false
}

variable "enable_policy" {
  description = "value to enable policy"
  type        = bool
  default     = false
}

variable "s3_bucket_policy" {
  description = "Política JSON para o bucket S3"
  type        = string
  default     = null
}
