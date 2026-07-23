locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dns       = read_terragrunt_config(find_in_parent_folders("dns.hcl"))
  internal  = local.dns.locals.internal.name
}

include {
    path = find_in_parent_folders()
}

terraform {
  source = local.enabled ? "../../../module_route53/zones" : null
}

dependency "vpc" {
    config_path = "../vpc_subnet"
}

inputs = {
    domain_name = local.internal
    prefix_name = local.internal
    is_public   = false
    vpc_id      = dependency.vpc.outputs.vpc_id

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}