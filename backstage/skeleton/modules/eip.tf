resource "aws_eip" "instance-eip" {
  domain = "vpc"
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}