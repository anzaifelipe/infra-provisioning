variable "secrets" {
  description = "Used tp create secrets with AWS Secrets Manager"
  type        = string
  default     = null
  sensitive   = true
}

variable "id" {
  description = "ID test"
  type        = string
  default     = null
  sensitive   = true  
}