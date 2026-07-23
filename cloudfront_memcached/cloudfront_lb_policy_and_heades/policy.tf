resource "aws_cloudfront_cache_policy" "this" {
  count = var.create_new_policy ? 1 : 0

  name        = var.policy_name
  comment     = var.policy_comment
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = ["locale"]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = var.policy_headers
      }
    }
    query_strings_config {
      query_string_behavior = "all"
      #query_strings {
      #  items = ["example"]
      #}
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}