variable "prefix_name" {
  type        = string
  description = "Set prefix name for all resources"
}

variable "dns_record_name" {
  type        = string
  description = "Public media URL"
}

variable "domain_origin_name" {
  type        = string
  description = "set domain name for CloudFront distribution"
}

variable "comment" {
  type        = string
  description = "Comment for CloudFront distribution"
}

variable "origin_id" {
  type        = string
  description = "set origin id for CloudFront distribution"
}

variable "acm_certificate_arn" {
  type        = string
  description = "*.prism.agilesvcs.com certificate"
}

variable "cache_allowed_methods" {
  type        = list(string)
  description = "Allowed methods for CloudFront distribution"
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  type        = list(string)
  description = "Cached methods for CloudFront distribution"
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  type        = string
  description = "Viewer protocol policy for CloudFront distribution"
  default     = "redirect-to-https"
}

variable "use_existing_cache_policy" {
  type        = bool
  description = "Use existing cache policy for CloudFront distribution"
  default     = false
}

variable "cache_policy_id" {
  type        = string
  description = "Cache policy id for CloudFront distribution"
  default     = null
}

variable "existing_policy_id" {
  type        = string
  description = "Existing cache policy id for CloudFront distribution"
  default     = null
}

variable "create_new_policy" {
  type        = bool
  description = "Create new cache policy for CloudFront distribution"
  default     = false
}

variable "policy_name" {
  type        = string
  description = "Cache policy name for CloudFront distribution"
}

variable "policy_comment" {
  type        = string
  description = "Cache policy comment for CloudFront distribution"
}

variable "policy_headers" {
  type        = list(string)
  description = "Cache policy headers for CloudFront distribution"
  default     = ["Accept", "Accept-Language", "Content-Language", "Origin"]
}

variable "create_new_headers_policy" {
  type        = bool
  description = "Create new headers policy for CloudFront distribution"
  default     = false
}

variable "headers_policy_name" {
  type        = string
  description = "Headers policy name for CloudFront distribution"
}

variable "headers_comment" {
  type        = string
  description = "Headers policy comment for CloudFront distribution"
}

variable "access_control_allow_headers" {
  type        = list(string)
  description = "value for access control allow headers"
}

variable "access_control_allow_methods" {
  type        = list(string)
  description = "value for access control allow methods"
}

variable "access_control_allow_origins" {
  type        = list(string)
  description = "value for access control allow origins"
}

variable "use_existing_headers_policy" {
  type        = bool
  description = "Use existing headers policy for CloudFront distribution"
  default     = false
}

variable "existing_headers_policy_id" {
  type        = string
  description = "Existing headers policy id for CloudFront distribution"
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
