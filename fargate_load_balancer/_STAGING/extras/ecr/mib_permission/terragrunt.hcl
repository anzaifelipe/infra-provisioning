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
    source = local.enabled ? "../../../../module_ecr" : null
}

inputs = {
    name        = "${local.project}-permission-${local.env}"
    mutability  = "MUTABLE"
    on_scan     = false

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}