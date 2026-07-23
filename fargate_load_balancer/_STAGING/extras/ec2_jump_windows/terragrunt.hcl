locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dest    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region  = local.dest.locals.region
  pair    = read_terragrunt_config(find_in_parent_folders("keypair.hcl"))
  key     = local.pair.locals.key
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_ec2_windows" : null
}

dependency "sg" {
    config_path = "../../baseline/security_groups/sg_mib_ec2_windows"
}

dependency "vpc" {
    config_path = "../../baseline/vpc_subnet"
}

inputs = {
    instance_type      = "t3a.medium"
    ec2_sg             = dependency.sg.outputs.security_group_id
    prefix_name        = "${local.project}-ec2-jump-${local.env}"
    key_pair           = local.key
    volume_size        = "50"
    subnet             = dependency.vpc.outputs.public_subnets[0]
    PLAT               = "amz"
    REGION             = local.region
    AUTOUPDATE         = "false"

    create_role        = false
    policy = null


    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}