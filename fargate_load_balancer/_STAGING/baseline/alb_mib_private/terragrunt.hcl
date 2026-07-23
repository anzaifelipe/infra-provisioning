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
    source = local.enabled ?  "../../../module_alb" : null
}

dependency "sg" {
    config_path = "../security_groups/sg_mib_services_private"
} 

dependency "vpc" {
    config_path = "../vpc_subnet"
}

inputs = {
    name                            = "${local.project}-mib-private-${local.env}"
    prefix_name                     = "${local.project}-mib-private-${local.env}"
    internal_flag                   = true 
    enable_deletion_protection_flag = false
    security_group_id               = [ dependency.sg.outputs.security_group_id ]
    vpc_id                          = dependency.vpc.outputs.vpc_id
    health_path                     = "/"
    redirect_to_https               = false
    use_ssl                         = false
    forward_to_https                = false
    listener_port                   = 80 
    listener_protocol               = "HTTP"
    #listener_policy                 = "ELBSecurityPolicy-2016-08"
    task_count                      = 1
    #certificate_arn                 = dependency.acm.outputs.certificate_arn
    subnets                         = dependency.vpc.outputs.private_subnets

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}  