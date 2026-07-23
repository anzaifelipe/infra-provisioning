variable "aws_region" {
  type        = string
  description = "Region for aws"
}

variable "prefix_name" {
  type        = string
  description = "Fixed name at start of any reource"
}

variable "create_role" {
  type        = bool
  description = "Set true or false to create an IAM role for ec2"
}

variable "policy" {
  description = "The JSON policy for the EC2. For more information about building AWS IAM policy documents with Terraform"
}

variable "instance_type" {
  type        = string
  description = "Amazon instance type using t3a.small is enough"
}

variable "vpcid" {
  type        = string
  description = "vpc id"
}

variable "subnet_first" {
  type        = string
  description = "subnet id"
}

/*
variable "access_key" {
  type = string
  description = "aws access key user"
}

variable "secret_key" {
  type = string
  description = "aws secret key user"
}

variable "git_token" {
  type = string
  description = "git token for clone repository"
}
*/


variable "git_username" {
  type        = string
  description = "User allowed to clone devops-utils repository"
}


variable "creds_name" {
  type        = string
  description = "AWS Secrets manager name"
}

variable "caddy_user" {
  type        = string
  description = "User for caddy application"
}

variable "caddy_password" {
  type        = string
  description = "Password for caddy application"
}

variable "domain" {
  type        = string
  description = "domain for grafana"
}

variable "monitor_sg" {
  type        = string
  description = "security group ID"
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
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}