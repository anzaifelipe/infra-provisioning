output "id" {
  value = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["${var.id}"]
  sensitive = true
}