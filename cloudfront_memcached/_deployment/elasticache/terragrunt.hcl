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
    source = local.enabled ? "../../../modules/module_ElasticCache" : null
}

dependency "sg" {
    config_path = "../security_groups/elasticache"
}

dependency "vpc" {
    config_path = "../vpc"
}

inputs = {
    cluster_name                = "${local.project}-mencached-${local.env}"
    create_memcached_cluster    = true
    description                 = "MemCached Cluster project: ${local.project} and environment: ${local.env}"
    instance_type               = "cache.t3.small"
    num_cache_nodes             = 2
    engine_version              = "1.6.17"
    security_group_ids          =  [ dependency.sg.outputs.security_group_id ]
    subnet_group_name           = "${local.project}-sub-group-${local.env}"
    is_public                   = false
    subnets_public              = dependency.vpc.outputs.public_subnets
    subnets_private             = dependency.vpc.outputs.private_subnets

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}