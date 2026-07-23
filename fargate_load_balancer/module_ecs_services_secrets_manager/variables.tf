# Naming variables
variable "cluster_id" {
  description = "Use the ID of cluster"
  type        = string
}

variable "target_group_arn" {
  description = "target group arn"
  type        = string
}

variable "secrets" {
  description = "Used tp create secrets with AWS Secrets Manager"
  type        = string
}

variable "operating_system_family" {
  description = "set opeaton system"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "set opeaton system"
  type        = string
  default     = "X86_64"
}

variable "service_name" {
  description = "set a name of services"
  type        = string
}

variable "readonly_filesystem" {
  description = "set a name of services"
  type        = bool
  default     = false
}

variable "assign_public_ip" {
  description = "set true or false"
  type        = bool
}

variable "enable_service_discovery" {
  description = "set true or false to enable service discovery"
  type        = bool
}


variable service_discovery_namespace_id {
  description = "The ID of the namespace to use for DNS configuration."
  type        = string
  default     = null
}

variable service_discovery_dns_ttl {
  description = "The amount of time, in seconds, that you want DNS resolvers to cache the settings for this resource record set."
  type        = number
  default     = 10
}

variable service_discovery_dns_record_type {
  description = "The type of the resource, which indicates the value that Amazon Route 53 returns in response to DNS queries. One of `A` or `SRV`."
  type        = string
  default     = "A"
}

variable service_discovery_routing_policy {
  description = "The routing policy that you want to apply to all records that Route 53 creates when you register an instance and specify the service. One of `MULTIVALUE` or `WEIGHTED`."
  type        = string
  default     = "MULTIVALUE"
}

variable service_discovery_failure_threshold {
  description = "The number of 30-second intervals that you want service discovery to wait before it changes the health status of a service instance. Maximum value of 10."
  type        = number
  default     = 1
}

variable service_discovery_container_port {
  description = "The port value, already specified in the task definition, to be used for your service discovery service."
  type        = number
  default     = null
}

variable service_discovery_container_name {
  description = "The container name value, already specified in the task definition, to be used for your service discovery service."
  type        = string
  default     = null
}

variable "service_namespace_name" {
  description = "define a namespace"
  type        = string
  default     = null
}

variable "description_namespace" {
  description = "describe the namespace"
  type        = string
  default     = null
}

variable "advanced_options" {
  description = "use to create unlimits and set runtime platform"
  type        = bool
  default     = false
}

variable "ecs_cluster_name" {
  description = "get a cluster name from ecs module"
  type        = string
}

variable "prefix_name" {
  description = "Set prefix name to resources"
  type        = string
}

variable "container_name" {
  description = "Set prefix name to resources"
  type        = string
}

variable "container_port" {
  description = "app port to container"
  type        = number
}

variable "softLimit" {
  description = "Unlimits configuration"
  type        = number
  default     = 1024
}

variable "hardLimit" {
  description = "Unlimits configuration"
  type        = number
  default     = 4096
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

variable "port_mapping" {
  description = "set ports in key/pair json encoded map"
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

variable "vpc_id" {
  description = "ID for the vpc created"
  type        = string
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

variable "desired_min" {
  description = "Number of tasks at low periods"
  default     = 1
  type        = number
}

variable "desired_count" {
  description = "set a number of how much instances from the same service will be running"
  type        = number
}

variable "desired_max" {
  description = "Number of tasks to launch on weekdays"
  default     = 1
  type        = number
}

