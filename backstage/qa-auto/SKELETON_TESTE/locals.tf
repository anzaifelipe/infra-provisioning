# locals.tf
locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Environment = "${{ values.environment }}"
    Owner       = "qa"
    Project     = "${{ values.project }}"
  }
  
  release_tag = "${{ values.releaseversion }}"
#  react_tag = "${{ values.reactversion }}"

  region = "us-east-1"

  mail = "noreply@org.com"

######
# RDS
######
  rds_instance_class = "${{ values.rdsinstance }}"
  rds_backup_snapshot = "${{ values.enablebackup }}"

######
# ec2 autos params
######
  instance_type = "${{ values.instancetype }}"
  server_tag = "${{ values.serverversion }}"
  agent_tag = "${{ values.agentversion }}"
  replicas_agent = "${{ values.replicasagent }}"

########
# ECS params
#########

# Filemanagement
  file_desired_count = "${{ values.fidesiredcount }}"
  file_desired_min = "${{ values.fidesiredmin }}"
  file_desired_max = "${{ values.fidesiredmax }}"

# Api
  api_desired_count = "${{ values.apidesiredcount }}"
  api_desired_min = "${{ values.apidesiredmin }}"
  api_desired_max = "${{ values.apidesiredmax }}"

# Auth
  auth_desired_count = "${{ values.authdesiredcount }}"
  auth_desired_min = "${{ values.authdesiredmin }}"
  auth_desired_max = "${{ values.authdesiredmax }}"

# Frontend
  frontend_desired_count = "${{ values.frontenddesiredcount }}"
  frontend_desired_min = "${{ values.frontenddesiredmin }}"
  frontend_desired_max = "${{ values.frontenddesiredmax }}"

# Frontend_react
  react_desired_count = "${{ values.reactdesiredcount }}"
  react_desired_min = "${{ values.reactdesiredmin }}"
  react_desired_max = "${{ values.reactdesiredmax }}"
  react_tag         = "${{ values.reactversion }}"

# Concurrency
  concurrency_desired_count = "${{ values.concurrencydesiredcount }}"
  concurrency_desired_min = "${{ values.concurrencydesiredmin }}"
  concurrency_desired_max = "${{ values.concurrencydesiredmax }}"

# Edithistory
  edithistory_desired_count = "${{ values.edithistorydesiredcount }}"
  edithistory_desired_min = "${{ values.edithistorydesiredmin }}"
  edithistory_desired_max = "${{ values.edithistorydesiredmax }}"

# Mailer
  mailer_desired_count = "${{ values.mailerdesiredcount }}"
  mailer_desired_min = "${{ values.mailerdesiredmin }}"
  mailer_desired_max = "${{ values.mailerdesiredmax }}"

# Mongo
  mongo_desired_count = "${{ values.mongodesiredcount }}"
  mongo_desired_min = "${{ values.mongodesiredmin }}"
  mongo_desired_max = "${{ values.mongodesiredmax }}"

# Permission
  permission_desired_count = "${{ values.permissionsdesiredcount }}"
  permission_desired_min = "${{ values.permissionsdesiredmin }}"
  permission_desired_max = "${{ values.permissionsdesiredmax }}"

# tsv
  tsv_desired_count = "${{ values.tsvdesiredcount }}"
  tsv_desired_min = "${{ values.tsvdesiredmin }}"
  tsv_desired_max = "${{ values.tsvdesiredmax }}"

  db_creds = {
    username = ""
    password = ""
  }

  tsvexport_mibtranslationconfig_enus_dictionary = "dictionary/en-US.mibconfig"
  tsvexport_mibtranslationconfig_ptbr_dictionary = "dictionary/pt-BR.mibconfig"
  tsvexport_mibtranslationconfig_esar_dictionary = "dictionary/es-AR.mibconfig"

  awsiam = {
        storageuser = {
            key     = ""
            secret  = ""
        },
        codedeploy  = {
            key     = ""
            secret  = ""
        },
        mibauth     = {
            key     = ""
            secret  = ""
        },
        assetimporter = {
            key     = ""
            secret  = ""
        },
        tsvexporter = {
            key     = ""
            secret  = ""
        },
        mailer      = {
            key     = ""
            secret  = ""
        }
    }
}
