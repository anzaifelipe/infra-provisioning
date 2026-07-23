variable "performance_mode" {
  description = " The file system performance mode. Can be either generalPurpose or maxIO (Default: generalPurpose."
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: bursting, provisioned, or elastic. When using provisioned, also set provisioned_throughput_in_mibps."
  type        = string
  default     = "bursting"
}

variable "subnets" {
  description = "The ID of the subnet to add the mount target in."
  type        = list(string)
  default     = []
}

variable "security_groups_id" {
  description = "A list of up to 5 VPC security group IDs (that must be for the same VPC as subnet specified) in effect for the mount target."
  type        = list(string)
  default     = []
}

variable "encrypted" {
  description = "If true, the disk will be encrypted"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name to use to indentify resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}