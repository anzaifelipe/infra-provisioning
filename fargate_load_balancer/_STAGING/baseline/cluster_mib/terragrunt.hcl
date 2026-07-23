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
    source = local.enabled ? "../../../module_ecs_cluster_fargate_only" : null
}

inputs = {

    prefix_name = "${local.project}-mib-cluster-${local.env}"
    ecs_name    = "${local.project}-mib-fargate-${local.env}"
    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}