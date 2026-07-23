resource "aws_cloudfront_distribution" "cloudfront_lb" {

  origin {
    domain_name = var.domain_origin_name
    origin_id   = var.origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
  comment = var.comment
  aliases = [var.dns_record_name]

  default_cache_behavior {
    allowed_methods            = var.cache_allowed_methods
    cached_methods             = var.cached_methods
    target_origin_id           = var.origin_id
    viewer_protocol_policy     = var.viewer_protocol_policy
    cache_policy_id            = var.use_existing_cache_policy ? var.existing_policy_id : aws_cloudfront_cache_policy.this[0].id
    response_headers_policy_id = var.use_existing_headers_policy ? var.existing_headers_policy_id : aws_cloudfront_response_headers_policy.this[0].id
    #forwarded_values {
    #  headers      = ["*"]
    #  query_string = true
    #  cookies {
    #    forward = "all"
    #  }
    #}

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 432000
    compress    = true

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
