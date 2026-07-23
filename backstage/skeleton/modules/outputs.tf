output "eip_address" {
  value = aws_eip.instance-eip.public_ip
}

output "ec2_name" {
  description = "Instance name"
  value       = var.prefix_name
}

output "zone_id" {
    value = var.zone_id
    description = "ID of Route53 zone"
}

output "dns_records" {
    value = var.dns_record_items
    description = "DNS records"
}

output "dns_alias_records" {
    value = var.dns_alias_records
    description = "DNS alias records"
}

output "dns_weighted_records" {
    value = var.dns_weighted_record_items
    description = "DNS Weighted records"
}

output "security_group_name" {
  description = "Name of Security Group"
  value       = var.security_group_name
}

output "security_group_id" {
  description = "ID of Security Group"
  value       = aws_security_group.sg-custom.id
}

output "security_group_vpc_id" {
  description = "VPC of Security Group"
  value       = var.vpc_id
}