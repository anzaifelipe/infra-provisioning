variable "name" {
  description = "A name used in CodeDeploy service"
  type        = string
}

variable "group_name" {
  description = "Used to create a CodeDeploy group name"
  type        = string
}

variable "server_name" {
  description = "Define the name of the ec2 code deploy agent server"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "roll_back" {
  description = "Set true or false to enable roll back"
  type        = bool
  default     = false
} 