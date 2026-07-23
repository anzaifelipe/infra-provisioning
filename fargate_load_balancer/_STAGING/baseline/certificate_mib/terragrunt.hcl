locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dns       = read_terragrunt_config(find_in_parent_folders("dns.hcl"))
  zone_id   = local.dns.locals.dns.zone_id
  zone_name = local.dns.locals.dns.zone_name
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_acm" : null
}

inputs = {
    prefix_name = "${local.project}-mib-services-${local.env}"
    domain = "*.${local.project}.${local.zone_name}"
    zone_id = local.zone_id


    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}  