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
    source = local.enabled ? "../../../module_s3" : null
}

inputs = {
    bucket_name = "${local.project}-importer-sqs-${local.env}"
    prefix_name = "${local.project}-importer-sqs-${local.env}"
    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}  