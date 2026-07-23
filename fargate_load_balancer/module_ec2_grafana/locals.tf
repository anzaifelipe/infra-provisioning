locals {
  common_tags = {
    Name      = "monitor-stack"
    ManagedBy = "Terraform"
  }

  subnets_tags = {
    Name      = "monitor-stack"
    ManagedBy = "Terraform"
  }

  node_tags = {
    Name      = "monitor-stack"
    ManagedBy = "Terraform"
  }

  grafanaMonitor = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}