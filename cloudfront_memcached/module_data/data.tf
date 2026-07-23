data "aws_secretsmanager_secret_version" "creds" {
  # Fill with the same name created in AWS console
  secret_id = var.secrets
} 