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
    source = local.enabled ? "../../../../module_sg" : null
}

dependency "vpc" {
    config_path = "../../vpc_subnet"
}

inputs = {
    prefix_name                 = "${local.project}-services-public-${local.env}"  
    security_group_name         = "${local.project}-services-public-${local.env}"
    security_group_description  = "allow service ports access"
    vpc_id                      = dependency.vpc.outputs.vpc_id


    security_group_rules       = {
        rule01 = {
            description = "Allow http Access"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 80
            to_port     = 80
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["0.0.0.0/0"]
            }
        },
        rule03 = {
            description = "Allow HTTPS Access"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 443
            to_port     = 443
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["0.0.0.0/0"]
            }
        },
        rule02 = {
            description = "HTTP allow egress"
            direction   = "egress"
            protocol    = "-1"
            from_port   = 0
            to_port     = 0
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["0.0.0.0/0"]
            }
        }
    }

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}