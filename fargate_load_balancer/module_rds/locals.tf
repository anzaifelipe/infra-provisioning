locals {
  #  create_db_subnet_group    = var.create_db_subnet_group && var.putin_khuylo
  #  create_db_parameter_group = var.create_db_parameter_group && var.putin_khuylo
  #  create_db_instance        = var.create_db_instance && var.putin_khuylo 

  create_db_subnet_group    = var.create_db_subnet_group
  create_db_parameter_group = var.create_db_parameter_group
  create_db_instance        = var.create_db_instance

  create_random_password = local.create_db_instance && var.create_random_password
  #  password               = local.create_random_password ? random_password.master_password[0].result : var.password
  password = local.create_random_password ? random_password.master_password[0].result : local.db_creds.password
  username = local.db_creds.username

  db_subnet_group_name    = var.create_db_subnet_group ? module.db_subnet_group.db_subnet_group_id : var.db_subnet_group_name
  parameter_group_name_id = var.create_db_parameter_group ? module.db_parameter_group.db_parameter_group_id : var.parameter_group_name

  create_db_option_group = var.create_db_option_group && var.engine != "postgres"
  option_group           = local.create_db_option_group ? module.db_option_group.db_option_group_id : var.option_group_name

  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}