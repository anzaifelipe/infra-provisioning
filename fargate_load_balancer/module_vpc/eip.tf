/*#######======================================================================================================
------------------Creating EIP Area
======================================================================================================#######*/
/*#######
EIP used for Nat Gateway, allow internet access from private subnet
#######*/
resource "aws_eip" "eip-nat" {
  count = length(var.private_subnets) > 0 && true == var.enbale_private_to_internet ? 1 : 0
  vpc   = true
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-nat-eip"
      )
    },
    var.tags,
  )
}