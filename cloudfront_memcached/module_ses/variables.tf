variable "domain" {
  description = "The domain to create the SES identity for."
  type        = string
}

variable "mail_from" {
  description = "The the mail from."
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 parent zone ID. If provided (not empty), the module will create Route53 DNS records used for verification"
  default     = ""
}

variable "mails_list" {
  description = "Set the e-mail addresses"
  type        = list(string)
  default     = []
}

variable "verify_domain" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for domain verification."
  default     = false
}

variable "verify_dkim" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for DKIM verification."
  default     = false
}