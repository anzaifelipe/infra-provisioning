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
  source = local.enabled ? "tfr:///terraform-aws-modules/vpc/aws?version=5.1.2" : null
}

inputs = {
    cidr                        = "10.77.8.0/22"
    name                        = "${local.project}-enricher-vpc-${local.env}"
    azs                         = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    public_subnets              = ["10.77.8.0/24", "10.77.9.0/24"]
    private_subnets             = ["10.77.10.0/24", "10.77.11.0/24"]
    enable_nat_gateway          = true
    enable_vpn_gateway          = false
    enable_dns_hostnames        = true

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}