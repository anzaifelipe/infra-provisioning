resource "aws_cloudfront_distribution" "cloudfront_lb" {

  dynamic "origin" {
    for_each = var.origin_lb
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      custom_origin_config {
        http_port              = origin.value.http_port
        https_port             = origin.value.https_port
        origin_protocol_policy = origin.value.origin_protocol_policy
        origin_ssl_protocols   = origin.value.origin_ssl_protocols
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin_s3
    content {
      domain_name = origin.value.domain_name_s3
      origin_id   = origin.value.origin_id_s3
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
    target_origin_id           = var.origin_id_tg
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


  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      response_headers_policy_id =ordered_cache_behavior.value.response_headers_policy_id
      
      forwarded_values {
        query_string = ordered_cache_behavior.value.query_string
        headers      = ordered_cache_behavior.value.headers
        cookies {
          forward = ordered_cache_behavior.value.forwarded_cookies
        }
      }      
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior_s3
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      response_headers_policy_id =ordered_cache_behavior.value.response_headers_policy_id    
    }
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
