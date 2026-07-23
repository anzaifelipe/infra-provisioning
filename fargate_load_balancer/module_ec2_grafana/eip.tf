resource "aws_eip" "monitor-eip" {
#  vpc  = true
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}