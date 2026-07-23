resource "aws_iam_policy" "custom" {
  count = var.create_policy ? 1 : 0

  name        = "${aws_iam_user.this.name}-custom-policy"
  description = var.policy_description
  policy      = var.policy_json
  tags = merge(
    {
      "Name" = format(
        "${var.name}"
      )
    },
    var.tags,
  )
}

resource "aws_iam_user_policy_attachment" "custom" {
  count = var.create_policy ? 1 : 0

  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.custom[0].arn
}

resource "aws_iam_user_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  user       = aws_iam_user.this.name
  policy_arn = each.value
}
