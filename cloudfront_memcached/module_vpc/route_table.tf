/*#######======================================================================================================
------------------Creating Route Tables
======================================================================================================#######*/
/*#######
Criation route table - allow external connection to all vpc
#######*/
resource "aws_route_table" "route-table-vpc" {
  count  = var.enable_external_access ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-vpc[0].id
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route-vpc-public"
      )
    },
    var.tags,
  )
}

/*#######
Criation route table - Public ingoing/outcoming Access for public subnets
#######*/
resource "aws_route_table" "route-table-public" {
  count  = length(var.public_subnets) > 0 && false == var.enable_external_access ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-subnet[0].id
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route-subnet-public"
      )
    },
    var.tags,
  )
}

/*#######
Criation route table - Only Internal Access for private subnets
#######*/
resource "aws_route_table" "route-table-private" {
  count  = length(var.private_subnets) > 0 && false == var.enbale_private_to_internet ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route-subnet-private"
      )
    },
    var.tags,
  )
}

/*#######
Criation route table - Only Internal Access for private subnets
#######*/
resource "aws_route_table" "route-table-nat" {
  count  = length(var.private_subnets) > 0 && true == var.enbale_private_to_internet ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-subnet[0].id
  }
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route-nat-private"
      )
    },
    var.tags,
  )
}