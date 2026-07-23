/*#######======================================================================================================
------------------Security Group 
======================================================================================================#######*/

resource "aws_security_group" "sg-custom" {
  vpc_id = var.vpc_id

  name        = var.security_group_name
  description = var.security_group_description

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}