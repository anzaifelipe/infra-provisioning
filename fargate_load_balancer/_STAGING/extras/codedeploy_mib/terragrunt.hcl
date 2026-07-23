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
    source = local.enabled ? "../../../module_codedeploy" : null
}

dependency "ec2" {
    config_path = "../ec2_mib_codedeploy"
}
inputs = {
    name        = "${local.project}-mib-codedeploy-${local.env}"
    group_name  = "${local.project}-mib-code-group-${local.env}"
    server_name = dependency.ec2.outputs.ec2_name
    roll_back   = false

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}    