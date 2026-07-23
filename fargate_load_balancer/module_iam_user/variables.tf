#############################
# User Config
#############################
variable "name" {
  description = "Nome do usuário IAM a ser criado."
  type        = string
}

variable "path" {
  description = "Caminho do usuário IAM (padrão /)."
  type        = string
  default     = "/"
}

variable "force_destroy" {
  description = "Se true, o usuário será destruído mesmo com recursos associados (chaves, etc)."
  type        = bool
  default     = false
}

variable "permissions_boundary_arn" {
  description = "ARN de uma permission boundary opcional para o usuário."
  type        = string
  default     = null
}

variable "groups" {
  description = "Lista de grupos IAM aos quais o usuário será adicionado."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags aplicadas ao usuário IAM e políticas."
  type        = map(string)
  default     = {}
}

#############################
# Custom Policy Config (opcional)
#############################
variable "create_policy" {
  description = "Define se uma policy customizada será criada e anexada ao usuário."
  type        = bool
  default     = false
}

variable "policy_description" {
  description = "Descrição da policy customizada (se criada)."
  type        = string
  default     = "Custom IAM Policy criada via Terraform"
}

variable "policy_json" {
  description = "JSON da policy customizada (usado se create_policy = true)."
  type        = string
  default     = null
}

#############################
# Managed Policies
#############################
variable "managed_policy_arns" {
  description = "Lista de ARNs de policies gerenciadas para anexar ao usuário (AWS ou custom)."
  type        = list(string)
  default     = []
}
