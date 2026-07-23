locals {
  enabled       = true
#  vars          = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
#  key           = local.vars.locals.keypair.key
#  Domain        = local.vars.locals.Domain.Domain_name
#  zone_id       = local.vars.locals.Domain.Domain_id
#  environment           = local.vars.locals.tags.environmentironment
#  project       = local.vars.locals.tags.project
#  db_pass       = local.vars.locals.passdb.password
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../modules" : null
}

inputs = {
    instance_type      = "${{ values.instancetype }}"
    prefix_name        = "${{ values.project }}-backstage-TC-${{ values.environment }}"
    key_pair           = "${{ values.keypair }}"
    volume_size        = "${{ values.volumesize }}"
    subnet             = "${{ values.subnetid }}"
    passdb             = "${{ values.sqlserverpassword }}"

    #DNS records
    domain             = "backstage-tc.${{ values.domain }}"
    zone_id            = "${{ values.zoneid }}"
    dns_record_items = {
        rule01 = {
            name = "backstage-tc.${{ values.domain }}"
            type = "A"
            ttl = 300
        }
    }

    #Security Group
    security_group_name         = "${{ values.project }}-backstage-TC-${{ values.environment }}"
    security_group_description  = "allow service ports access"
    vpc_id                      = "${{ values.vpcid }}"

    security_group_rules       = {
        rule01 = {
            description = "Allow Agile Office SP primary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 22
            to_port     = 22
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["189.39.44.68/32"]
            }
        },        
        rule03 = {
            description = "Allow Agile Office SP secondary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 22
            to_port     = 22
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["201.6.159.217/32"]
            }
        }, 
        rule04 = {
            description = "Allow HTTP Access Anywhere"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 80
            to_port     = 80
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["0.0.0.0/0"]
            }
        },        
        rule05 = {
            description = "Allow HTTPS Access Anywhere"
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

    tags = {
        ManagedBy       = "Terraform-Terragrunt"
        environment     = "${{ values.environment }}"
        Owner           = "fast"
        project         = "${{ values.project }}"
        DateCreated     = "2024-07-29"
        TerragruntPath  = path_relative_to_include()
    }
}