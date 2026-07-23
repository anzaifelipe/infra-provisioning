output "app_arn" {
  description = "The ARN of the CodeDeploy application"
  value       = aws_codedeploy_app.this.arn
}

output "application_id" {
  description = "The application ID"
  value       = aws_codedeploy_app.this.application_id
}

output "name" {
  description = "The application's name."
  value       = aws_codedeploy_app.this.name
}

output "group_arn" {
  description = "The ARN of the CodeDeploy deployment group"
  value       = aws_codedeploy_deployment_group.this.arn
}

output "group_id" {
  description = "Application name and deployment group name."
  value       = aws_codedeploy_deployment_group.this.id
}