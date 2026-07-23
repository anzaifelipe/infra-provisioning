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
    prefix_name                 = "${local.project}-LOWI-EXT-${local.env}"
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

    origin_s3 = {
      origin_s3_1 = {
        domain_name_s3 = ""
        origin_id_s3   = "certificates"
      }
    }

    comment                     = " Kong WEB EXT"
    dns_record_name             = ""
    acm_certificate_arn         = ""
    cache_allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods              = ["GET", "HEAD"] #or use ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy      = "redirect-to-https"
    use_existing_cache_policy   = true
    use_existing_headers_policy = false
    existing_policy_id          = "ae798bfc-d231-47fa-880c-000bb4604975"

    create_new_policy           = false
    policy_name                 = "${local.project}-Lowi-${local.env}"
    policy_comment              = "This is only a teste for ${local.project} in env ${local.env}"
    policy_headers              = ["origin", "Authorization", "X-Locale", "CloudFront-Is-Tablet-Viewer", "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Desktop-Viewer", "CloudFront-Is-SmartTV-Viewer", "Referer", "X-Referer", "Host"]
    
    create_new_headers_policy   = true
    existing_headers_policy_id  = null
    headers_policy_name         = "CORS-Allowed-Lowi-Prod-ext"
    headers_comment             = "CORS used in Lowi Project External"
    access_control_allow_headers = [
                      "Content-Type",
                      "Origin",
                      "X-Auth-Token",
                      "Authorization",
                      "Cache-Control",
                      "Vary",
                      "X-Referer",
                      "Access-Control-Allow-Origin",
                      "X-Api-Pocus-Key",
                      "X-Api-Pocus-Device"
                    ]
    access_control_allow_methods = [
                      "DELETE",
                      "GET",
                      "OPTIONS",
                      "POST",
                      "PUT"
                    ]
    access_control_allow_origins = [
                      "https://",
                      "https://",
                      "https://",
                      "https://",
                      "https://"
                    ]
      
    ordered_cache_behavior_s3 = {
      behavior1 = {
        path_pattern = "/fairplay.cer"
        allowed_methods = ["GET", "HEAD"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "certificates" ##Very same name as the origin_id_s3 on origin_s3 block
        viewer_protocol_policy = "allow-all"
        cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
        response_headers_policy_id = null
      }
    }

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}