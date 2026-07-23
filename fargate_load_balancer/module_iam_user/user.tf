resource "aws_iam_user" "this" {
  name                 = var.name
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary_arn
  tags = merge(
    {
      "Name" = format(
        "${var.name}"
      )
    },
    var.tags,
  )
}

resource "aws_iam_user_group_membership" "this" {
  count = length(var.groups) > 0 ? 1 : 0

  user   = aws_iam_user.this.name
  groups = var.groups
}
