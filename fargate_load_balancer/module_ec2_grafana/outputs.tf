output "eip_address" {
  value = aws_eip.monitor-eip.public_ip
}

output "ec2_name" {
  description = "Instance name"
  value       = var.prefix_name
}