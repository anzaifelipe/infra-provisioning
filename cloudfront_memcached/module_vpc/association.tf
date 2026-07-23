/*#######======================================================================================================
------------------Association
======================================================================================================#######*/
/*#######
route table association with vpc, makes main vpc table
#######*/
resource "aws_main_route_table_association" "assoc" {
  count          = var.enable_external_access ? 1 : 0
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.route-table-vpc[0].id
}

/*#######
route table association public subnets
#######*/
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 && false == var.enable_external_access ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.route-table-public[0].id
}

/*#######
route table association private subnets
#######*/
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 && false == var.enbale_private_to_internet ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.route-table-private[0].id
}

/*#######
route table association nat route for private subnets
#######*/
resource "aws_route_table_association" "private-nat" {
  count = length(var.private_subnets) > 0 && true == var.enbale_private_to_internet ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.route-table-nat[0].id
}