/*#######======================================================================================================
------------------Creating Nat Gateway for outgoing subnet
======================================================================================================#######*/
/*#######
net gateway only for outgoing requests, allow access to internet for private subnet
#######*/
resource "aws_nat_gateway" "nat-gw-subnet" {
  count = length(var.private_subnets) > 0 && true == var.enbale_private_to_internet ? 1 : 0

  allocation_id = aws_eip.eip-nat[0].id
  subnet_id     = element(aws_subnet.private[*].id, count.index)
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-nat-private-subnet"
      )
    },
    var.tags,
  )
}