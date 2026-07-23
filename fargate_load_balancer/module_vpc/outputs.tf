output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "igw_id" {
  value = try(aws_internet_gateway.igw-vpc[0].id, "")
}

output "route_table_vpc_id" {
  value = try(aws_route_table.route-table-vpc[0].id, "")
}

output "route_table_public_id" {
  value = try(aws_route_table.route-table-public[0].id, "")
}

output "route_table_private_id" {
  value = try(aws_route_table.route-table-private[0].id, "")
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "eip-nat" {
  description = "Eip used to allow internet access for private subnet"
  value       = try(aws_eip.eip-nat[0].id, "")
}