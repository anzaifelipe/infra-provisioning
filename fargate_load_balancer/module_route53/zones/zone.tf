resource "aws_route53_zone" "hosted_zone" {
  count = var.is_public ? 1 : 0
  name = var.domain_name

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route53_zone"
      )
    },
    var.tags,
  )
}

resource "aws_route53_zone" "hosted_zone_private" {
  count = var.is_public ? 0 : 1
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-route53_zone"
      )
    },
    var.tags,
  )
}