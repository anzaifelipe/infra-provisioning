# locals.tf
locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Environment = "${{ values.environment }}"
    Owner       = "qa"
    Project     = "${{ values.project }}"
  }
}
