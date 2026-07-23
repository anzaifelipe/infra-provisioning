locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ?  "../../../modules/cloudfront_dynamic" : null
}

dependency "vpc" {
  config_path = "../../baseline/vpc"
}

dependency "sg" {
  config_path = "../../baseline/security_groups/private"
}

dependency "lb" {
  config_path = "../../baseline/alb_public_apigateway"
}


inputs = {
    prefix_name                 = "${local.project}-EXT-${local.env}"
    origin_id_tg                = dependency.lb.outputs.alb_dns_name

    origin_lb  = {
      origin_lb_1 = {
        domain_name = dependency.lb.outputs.alb_dns_name
        origin_id   = dependency.lb.outputs.alb_dns_name
        http_port   = 80
        https_port  = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    comment                     = "Kong API"
    dns_record_name             = ""
    acm_certificate_arn         = ""
    cache_allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods              = ["GET", "HEAD"] #or use ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy      = "redirect-to-https"
    use_existing_cache_policy   = true
    use_existing_headers_policy = true
    existing_policy_id          = "22401f0f-d828-4b18-b650-83f709e4e378"

    create_new_policy           = false
    policy_name                 = ""
    policy_comment              = ""
    policy_headers              = []
    
    create_new_headers_policy   = false
    existing_headers_policy_id  = "2dbc85bc-890f-43e4-970e-37cccd7c71ad"
    headers_policy_name         = ""
    headers_comment             = ""
    access_control_allow_headers = [
                    ]
    access_control_allow_methods = [
                    ]
    access_control_allow_origins = [
                    ]


    ordered_cache_behavior = {
      behavior1 = {
        path_pattern = "*/authentication/*"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      },
      behavior2 = {
        path_pattern = "*/user*"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      },
      behavior3 = {
        path_pattern = "*/private-*/*"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      },
      behavior4 = {
        path_pattern = "*/media/*"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      },
      behavior5 = {
        path_pattern = "*/settings/debug/headers"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      },
      behavior6 = {
        path_pattern = "*/analytics/*"
        allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = dependency.lb.outputs.alb_dns_name
        viewer_protocol_policy = "redirect-to-https"
        forwarded_cookies = "all"
        query_string = true
        headers      = ["*"]
        response_headers_policy_id = "2dbc85bc-890f-43e4-970e-37cccd7c71ad" ##can be null
      }
    }

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}