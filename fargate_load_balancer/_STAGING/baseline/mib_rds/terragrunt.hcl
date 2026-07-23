locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  mssql   = read_terragrunt_config(find_in_parent_folders("credentials.hcl"))
  creds   = local.mssql.locals.mssql.creds
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_rds" : null
}


dependency "sg" {
    config_path = "../security_groups/sg_mib_rds"
}

dependency "vpc" {
    config_path = "../vpc_subnet"
}

inputs = {
    create_db_instance = true
#    create_db_option_group = false
    create_db_parameter_group = false
    create_db_subnet_group = true
    create_monitoring_role = true

    identifier            = "${local.project}-db-mib-${local.env}"
    engine                = "sqlserver-web"
    engine_version        = "15.00.4236.7.v1",
    instance_class        = "db.t3.medium"
    license_model         = "license-included",
    allocated_storage     = 20
    max_allocated_storage = 1000
    port                  = 1433
    character_set_name    = "SQL_Latin1_General_CP1_CI_AS"
    multi_az              = false
    
    performance_insights_enabled            = true
    performance_insights_retention_period   = 7
    
    major_engine_version    = "15.00"

    create_random_password = false ##if set FALSE, make sure to have secrets manager created, use techdocs for documentation
#    db_name  = "itaas"
    db_secrets = local.creds
#    username = "user"
    publicly_accessible = true
#    iam_database_authentication_enabled = false
    
    vpc_security_group_ids = [dependency.sg.outputs.security_group_id]
    subnet_ids             = dependency.vpc.outputs.public_subnets
    maintenance_window = "fri:22:22-fri:22:52" ##Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
    backup_window      = "03:29-03:59" #Example: '09:46-10:16'. Must not overlap with maintenance_window"
    enabled_cloudwatch_logs_exports = []
 #   monitoring_interval = "30"
    monitoring_role_name = "${local.project}-RDSMonitoringRoleMib-${local.env}"

    backup_retention_period = 1
    skip_final_snapshot     = false
    deletion_protection     = true
    storage_encrypted       = false


#    parameters = [
#        {
#        name = "character_set_client"
#        value = "utf8mb4"
#        },
#        {
#        name = "character_set_server"
#        value = "utf8mb4"
#        }
#    ]

 #   option_group_name            = "prod-instance-postman-14-1"  #only lowercase alphanumeric characters and hyphens allowed in "name"
 #   option_group_use_name_prefix = false

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}