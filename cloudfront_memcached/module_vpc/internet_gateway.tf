/*#######======================================================================================================
------------------Creating Internet Gateway Area
======================================================================================================#######*/
/*#######
criação da Internet Gateway - permite conexões externas
#######*/
resource "aws_internet_gateway" "igw-vpc" {
  count  = var.enable_external_access ? 1 : 0
  vpc_id = aws_vpc.vpc.id ##Associa à VPC criado para o EKS
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-igw-vpc"
      )
    },
    var.tags,
  )
}

/*#######
criação da Internet Gateway - permite conexões externas
#######*/
resource "aws_internet_gateway" "igw-subnet" {
  count  = length(var.public_subnets) > 0 && false == var.enable_external_access ? 1 : 0
  vpc_id = aws_vpc.vpc.id ##Associa à VPC criado para o EKS
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-igw-subnet"
      )
    },
    var.tags,
  )
}