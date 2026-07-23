resource "aws_iam_policy" "ec2_policy" {
  count = var.create_role ? 1 : 0

  name        = "${var.prefix_name}-iamPolicy"
  path        = "/"
  description = "POlicy used in ec2 instance: ${var.prefix_name}"
  policy      = var.policy

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}

resource "aws_iam_role" "ec2_role" {
  count = var.create_role ? 1 : 0

  name = "${var.prefix_name}-iamRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  count      = var.create_role ? 1 : 0
  name       = "${var.prefix_name}-policyAttachment"
  roles      = [aws_iam_role.ec2_role[0].name]
  policy_arn = aws_iam_policy.ec2_policy[0].arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_role ? 1 : 0
  name  = "${var.prefix_name}-ec2Profile"
  role  = aws_iam_role.ec2_role[0].name
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}