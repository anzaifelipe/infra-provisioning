# Naming variables
variable "ecs_name" {
  description = "Name primitive to use for all resources created"
}

variable "prefix_name" {
  description = "Set prefix name to resources"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# IAM
variable "execution_iam_access" {
  description = "A complex object describing additional access beyond AmazonECSTaskExecutionRolePolicy needed to run"
  type        = map(list(string))
}
variable "task_role_arn" {
  description = "ARN of the role to assign to the launched container"
  type        = string
  default     = null
}

# Fargate
variable "fargate_cpu" {
  description = "CPU size for fargate"
  default     = 1024
  type        = number
}
variable "fargate_mem" {
  description = "Memory to use for fargate"
  default     = 2048
  type        = number
}

# Builder container
variable "container_cpu" {
  description = "CPU to use for container, must be equal or less than fargate"
  default     = 1024
  type        = number
}
variable "container_mem" {
  description = "Memory to use for container, must be equal or less than fargate"
  default     = 2048
  type        = number
}

# Task
variable "image_ecr_url" {
  description = "URL of the ECR where the builder image is stored"
  type        = string
}
variable "image_tag" {
  description = "Tag to use when pulling ECR image"
  default     = "latest"
  type        = string
}
variable "task_environment_variables" {
  description = "Environmental variables in key/pair json encoded map"
  type        = list(any)
  default     = []
}
variable "task_secret_environment_variables" {
  description = "Environmental variables in key/pair json encoded map"
  default     = []
}

#variable "app_port" {
#  description = "Docker Image port"
#}

# Service
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "is_public" {
  description = "Set true or false for public ECS"
  type        = bool
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "security_group_id" {
  description = "Security groups to assign to builder containers"
  type        = string
}

# Autoscaling
#variable "enable_scaling" {
#  description = "Enable automatic scaling and cycle down overnight"
#  type        = bool
#  default     = true
#}

variable "autoScale_daytime" {
  description = "Enable automatic scaling and cycle down overnight"
  type        = bool
}

variable "autoScale_resource_usage" {
  description = "Enable automatic scaling based on cpu usage"
  type        = bool
}

variable "autoscale_task_weekday_scale_down" {
  description = "Number of tasks at low periods"
  default     = 1
  type        = number
}
variable "autoscale_task_weekday_scale_up" {
  description = "Number of tasks to launch on weekdays"
  default     = 1
  type        = number
}

