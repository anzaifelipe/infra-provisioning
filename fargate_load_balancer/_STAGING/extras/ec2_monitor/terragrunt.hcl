locals {
  enabled       = true
  common        = read_terragrunt_config(find_in_parent_folders("monitor.hcl"))
  env           = local.common.locals.tags.Environment
  project       = local.common.locals.tags.Project
  zone_id       = local.common.locals.domain.domain_id
  zone_name     = local.common.locals.domain.domain_name
  key           = local.common.locals.keypair.key
  git_username  = local.common.locals.ec2.git_username
  creds_name    = local.common.locals.ec2.creds_name
  caddy_user    = local.common.locals.ec2.caddy_user
  caddy_password  = local.common.locals.ec2.caddy_password
  region        = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region    = local.region.locals.region
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_ec2_grafana" : null
}

dependency "sg" {
    config_path = "../../baseline/security_groups/sg_mib_ec2_monitor"
}

dependency "vpc" {
    config_path = "../../baseline/vpc_subnet"
}

inputs = {
    instance_type      = "t3.medium"
    monitor_sg         = dependency.sg.outputs.security_group_id
    prefix_name        = "${local.project}-monitor-${local.env}"
    vpcid              = dependency.vpc.outputs.vpc_id
    key_pair           = local.key
    volume_size        = "40"
    aws_region         = local.aws_region
    subnet_first       = dependency.vpc.outputs.public_subnets[0]
    git_username       = local.git_username
    creds_name         = local.creds_name
    caddy_user         = local.caddy_user
    caddy_password     = local.caddy_password
    domain             = "monitor.${local.zone_name}"
    host_zone_id       = local.zone_id

    create_role        = false
    policy = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    #"ec2:*",
                    #"rds:*",
                    "s3:*"
                ],
                Resource = "*"
            },
        ]
    })


    tags = merge(
      local.common.locals.tags,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}