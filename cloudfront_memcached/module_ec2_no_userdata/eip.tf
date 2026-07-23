resource "aws_eip" "ec2-eip" {
  vpc = true
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}