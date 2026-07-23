resource "aws_acm_certificate" "this" {
  domain_name       = var.domain
  validation_method = var.validation_method
  # subject_alternative_names = var.alternative_domains

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-acm"
      )
    },
    var.tags,
  )

}