variable "instance_type" {
  type        = string
  description = "Amazon instance type using t3a.small is enough"
}

variable "ec2_sg" {
  type        = string
  description = "security group ID"
}

variable "create_role" {
  type        = bool
  description = "Set true or false to create an IAM role for ec2"
}

variable "policy" {
  description = "The JSON policy for the EC2. For more information about building AWS IAM policy documents with Terraform"
}

variable "volume_size" {
  type        = number
  description = "instance volume size in GB"
}

variable "prefix_name" {
  description = "Used for tags"
  type        = string
}

variable "REGION" {
  description = "set the region"
  type        = string
}

variable "AUTOUPDATE" {
  description = "used in script"
  type        = string
}

variable "PLAT" {
  description = "set the system platform, amz or ubuntu"
  type        = string
}

variable "key_pair" {
  description = "Key pair SSH name"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet" {
  description = "subnet ID"
  type        = string
}