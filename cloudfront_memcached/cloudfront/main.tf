resource "aws_cloudfront_distribution" "cloudfront_public_medias" {
  
  origin {
    domain_name = var.bucket_public_medias_name
    origin_id   = var.bucket_public_medias_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
  comment             = var.comment
  aliases = [var.host_name_medias_public]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_public_medias_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 432000
    compress               = true
    
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn         = var.certificate_agile_svcs
    ssl_support_method          = "sni-only"
    minimum_protocol_version    = "TLSv1.2_2021"
  }
}
