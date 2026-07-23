resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = var.on_scan
  }
  tags = merge(
    {
      "Name" = format(
        "${var.name}"
      )
    },
    var.tags,
  )
}