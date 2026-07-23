output "user_name" {
  description = "Nome do usuário IAM criado."
  value       = aws_iam_user.this.name
}

output "user_arn" {
  description = "ARN do usuário IAM criado."
  value       = aws_iam_user.this.arn
}

output "user_path" {
  description = "Caminho do usuário IAM criado."
  value       = aws_iam_user.this.path
}

output "custom_policy_arn" {
  description = "ARN da policy customizada criada (se existir)."
  value       = try(aws_iam_policy.custom[0].arn, null)
}
