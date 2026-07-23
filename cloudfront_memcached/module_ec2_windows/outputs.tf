output "eip-ec2" {
  description = "EIP used on EC2"
  value       = aws_eip.ec2-eip.public_ip
}

output "ec2_name" {
  description = "Instance name"
  value       = var.prefix_name
}