resource "aws_cloudfront_response_headers_policy" "this" {
  count = var.create_new_headers_policy ? 1 : 0

  name    = var.headers_policy_name
  comment = var.headers_comment

  cors_config {
    access_control_allow_credentials = true

    access_control_allow_headers {
      items = var.access_control_allow_headers
    }

    access_control_allow_methods {
      items = var.access_control_allow_methods
    }

    access_control_allow_origins {
      items = var.access_control_allow_origins
    }
    access_control_max_age_sec = 600
    origin_override            = true
  }
}