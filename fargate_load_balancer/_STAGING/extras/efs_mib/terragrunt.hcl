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
    source = local.enabled ?  "../../../module_efs" : null
}

dependency "sg" {
  config_path = "../../baseline/security_groups/sg_mib_services_private"
}

dependency "vpc" {
  config_path = "../../baseline/vpc_subnet"
}

inputs = {
    name                = "${local.project}-mib-efs-${local.env}"
    performance_mode    = "generalPurpose"
    throughput_mode     = "bursting"
    encrypted           = true
    subnets             = dependency.vpc.outputs.private_subnets
    security_groups_id  = [dependency.sg.outputs.security_group_id]

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}