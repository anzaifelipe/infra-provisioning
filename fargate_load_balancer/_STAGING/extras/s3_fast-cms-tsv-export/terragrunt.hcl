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
    bucket_name = "${local.project}-cms-tsv-export-${local.env}"
    prefix_name = "${local.project}-cms-tsv-export-${local.env}"

    enable_acl              = true
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
    object_ownership        = "ObjectWriter"

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}  