terraform { 
  backend "s3" { 
    # coloque o nome do bucket abaixo! 
    bucket         = "" 
    key            = "backstage//${{ values.project }}/${{ values.environment }}/terraform.tfstate" 
    region         = "eu-west-1" 
    encrypt        = true 
  } 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }
} 

provider "aws" {
  region  = "us-east-1"
}

module "sg_rds" {
    source                      = "../../module_sg"

    prefix_name                 = "${local.common_tags.Project}-rds-private-${local.common_tags.Environment}"  
    security_group_name         = "${local.common_tags.Project}-rds-private-${local.common_tags.Environment}"
    security_group_description  = "allow service ports access"
    vpc_id                      = ""

    security_group_rules       = {
        rule01 = {
            description = "Allow SQL VPC Access"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
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
        },        
        rule03 = {
            description = "Allow Agile Office SP primary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
            }
        },        
        rule04 = {
            description = "Allow Agile Office SP secondary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
            }
        },
    }

  tags = merge(local.common_tags, {
  })

}

module "sg_private" {
    source                      = "../../module_sg"

    prefix_name                 = "${local.common_tags.Project}-services-private-${local.common_tags.Environment}"  
    security_group_name         = "${local.common_tags.Project}-services-private-${local.common_tags.Environment}"
    security_group_description  = "allow service ports access"
    vpc_id                      = ""

    security_group_rules       = {
        rule04 = {
            description = "Allow VPC Access"
            direction   = "ingress"
            protocol    = "-1"
            from_port   = 0
            to_port     = 0
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
            }
        },
        rule07 = {
        description = "EFS Access"
        direction   = "ingress"
        protocol    = "tcp"
        from_port   = 2049
        to_port     = 2049
        addresses = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
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

  tags = merge(local.common_tags, {
  })
}

module "sg_public" {
    source                      = "../../module_sg"

    prefix_name                 = "${local.common_tags.Project}-services-public-${local.common_tags.Environment}"  
    security_group_name         = "${local.common_tags.Project}-services-public-${local.common_tags.Environment}"
    security_group_description  = "allow service ports access"
    vpc_id                      = ""

    security_group_rules       = {
        rule04 = {
            description = "Allow VPC Access"
            direction   = "ingress"
            protocol    = "-1"
            from_port   = 0
            to_port     = 0
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = [""]
            }
        },  
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
  tags = merge(local.common_tags, {
  })
}

module "certificate" {
    source                      = "../../module_acm"

    prefix_name = "${local.common_tags.Project}--services-${local.common_tags.Environment}"
    domain = "*.${local.common_tags.Project}.platform..solutions"
    zone_id = ""

  tags = merge(local.common_tags, {
  })
}

module "alb_private" {
    source                      = "../../module_alb"

    name                            = "${local.common_tags.Project}--private-${local.common_tags.Environment}"
    prefix_name                     = "${local.common_tags.Project}--private-${local.common_tags.Environment}"
    internal_flag                   = true 
    enable_deletion_protection_flag = false
    security_group_id               = [ module.sg_private.security_group_id ]
    vpc_id                          = ""
    health_path                     = "/"
    redirect_to_https               = false
    use_ssl                         = false
    forward_to_https                = false
    listener_port                   = 80 
    listener_protocol               = "HTTP"
    #listener_policy                 = "ELBSecurityPolicy-2016-08"
    #certificate_arn                 = dependency.acm.outputs.certificate_arn
    subnets                         = []

  tags = merge(local.common_tags, {
  })   
}

module "alb_public" {
    source                      = "../../module_alb"

    name                            = "${local.common_tags.Project}--public-${local.common_tags.Environment}"
    prefix_name                     = "${local.common_tags.Project}--public-${local.common_tags.Environment}"
    internal_flag                   = false 
    enable_deletion_protection_flag = false
    security_group_id               = [ module.sg_public.security_group_id ]
    vpc_id                          = ""
    health_path                     = "/"
    redirect_to_https               = true
    use_ssl                         = true
    forward_to_https                = false
    listener_port                   = 443 
    listener_protocol               = "HTTPS"
    listener_policy                 = "ELBSecurityPolicy-2016-08"
    certificate_arn                 = module.certificate.certificate_arn
    subnets                         = []

  tags = merge(local.common_tags, {
  })   
}

module "rds" {
    source = "../../module_rds_snapshot"

    create_db_instance = true
    create_db_parameter_group = false
    create_db_subnet_group = true
    create_monitoring_role = true

    rds_backup_snapshot = local.rds_backup_snapshot

    identifier            = "${local.common_tags.Project}-db--qa-${local.common_tags.Environment}"
    option_group_name     = "${local.common_tags.Project}-db--qa-${local.common_tags.Environment}"
    engine                = "sqlserver-web"
    engine_version        = "15.00.4236.7.v1"
    instance_class        = local.rds_instance_class
    license_model         = "license-included"
    allocated_storage     = 30
    max_allocated_storage = 1000
    port                  = 1433
    character_set_name    = "SQL_Latin1_General_CP1_CI_AS"
    multi_az              = false
    
    performance_insights_enabled            = true
    performance_insights_retention_period   = 7
    
    major_engine_version    = "15.00"

    create_random_password = false ##if set FALSE, make sure to have secrets manager created, use techdocs for documentation
#    db_name  = "itaas"
    db_secrets = "db-creds"
#    username = "user"
    publicly_accessible = true
#    iam_database_authentication_enabled = false
    
    vpc_security_group_ids = [module.sg_rds.security_group_id]
    subnet_ids             = []
    maintenance_window = "fri:22:22-fri:22:52" ##Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
    backup_window      = "03:29-03:59" #Example: '09:46-10:16'. Must not overlap with maintenance_window"
    enabled_cloudwatch_logs_exports = []
 #   monitoring_interval = "30"
    monitoring_role_name = "${local.common_tags.Project}-RDSMonitoring-${local.common_tags.Environment}"

    backup_retention_period = 0
    skip_final_snapshot     = true
    deletion_protection     = false
    storage_encrypted       = false

  tags = merge(local.common_tags, {
  })   
}

module "ecs_cluster" {
  source = "../../module_ecs_cluster_fargate_only"

    prefix_name = "${local.common_tags.Project}--cluster-${local.common_tags.Environment}"
    ecs_name    = "${local.common_tags.Project}--fargate-${local.common_tags.Environment}"
  
  tags = merge(local.common_tags, {
  })  
}

module "zone_internal" {
  source = "../../module_route53/zones"

  domain_name = "internal.${local.common_tags.Project}-${local.common_tags.Environment}.solutions"
  prefix_name = "internal.${local.common_tags.Project}-${local.common_tags.Environment}.solutions"
  is_public   = false
  vpc_id      = ""

  tags = merge(local.common_tags, {
  })  
}


module "dns_rds" {
  source = "../../module_route53/records"

  zone_id = module.zone_internal.zone_id_private
  dns_record_items = {
    rule01 = {
      name = "${local.common_tags.Project}-mssqldb-${local.common_tags.Environment}.${module.zone_internal.name_private}" 
      type = "CNAME"
      ttl = 300
      records = [module.rds.db_instance_address]
    }
  }
}

module "efs" {
  source = "../../module_efs"

    name                = "${local.common_tags.Project}--efs-${local.common_tags.Environment}"
    performance_mode    = "generalPurpose"
    throughput_mode     = "bursting"
    encrypted           = true
    subnets             = []
    security_groups_id  = [module.sg_private.security_group_id]

  tags = merge(local.common_tags, {
  })  
}

module "sqs" {
  source = "../../module_sqs"

    name                        = "${local.common_tags.Project}--${local.common_tags.Environment}.fifo"
    content_based_deduplication = false 
    deduplication_scope         = "queue"
    delay_seconds               = 0
    fifo_queue                  = true
    fifo_throughput_limit       = "perQueue"
    max_message_size            = 262144
    message_retention_seconds   = 345600
    receive_wait_time_seconds   = 0
    visibility_timeout_seconds  = 30
    
    policy = jsonencode(
            {
                Id        = "__default_policy_ID"
                Statement = [
                    {
                        Action    = "SQS:*"
                        Effect    = "Allow"
                        Principal = {
                            AWS = "arn:aws:iam::000000:user/-assetimporter-staging"
                        }
                        Resource  = "arn:aws:us-east-1:000000:${local.common_tags.Project}--${local.common_tags.Environment}.fifo"
                        Sid       = "__owner_statement"
                    },
                ]
                Version   = "2012-10-17"
            }
        )

  tags = merge(local.common_tags, {
  })
}

module "ecs_mongodb" {
  source = "../../module_services_baseline_url_efs"

    task_environment_variables = [
                {
                    name : "",
                    value: ""
                },
                { "name": "", "value": "true"},
                { "name": "", "value": "false"},
                { "name": "", "value": "true"}
    ]

    rule_hosted_based = {
        rule01 = {
            #target_group_arn = dependency.target_mongodb.outputs.target_group_arn
            priority = 90
            type = "forward"
            host  = ["${local.common_tags.Project}-mongodb-${local.common_tags.Environment}.${module.zone_internal.name_private}"]
        }
    }

    dns_alias_records = {
        rule01 = {
            name = "${local.common_tags.Project}-mongodb-${local.common_tags.Environment}.${module.zone_internal.name_private}"
            type = "A"
            alias_name = module.alb_private.alb_dns_name,
            alias_zone_id  = module.alb_private.alb_zone_id,
            alias_target_health = true
        }
    }

    prefix_name                 = "${local.common_tags.Project}--mongodb-${local.common_tags.Environment}"
    tg_name                     = "${local.common_tags.Project}--mongodb-${local.common_tags.Environment}"
    cluster_id                  = module.ecs_cluster.ecs_cluster_id
    ecs_cluster_name            = module.ecs_cluster.ecs_cluster_name
    vpc_id                      = ""
    public_subnets              = []
    private_subnets             = [""]
    security_group_id           = module.sg_private.security_group_id
    service_name                = "${local.common_tags.Project}--mongodb-${local.common_tags.Environment}"
    is_public                   = false
    assign_public_ip            = false
    autoScale_resource_usage    = true
    fargate_cpu                 = 512
    fargate_mem                 = 1024
    container_cpu               = 512
    container_mem               = 1024
    container_port              = 27017
    desired_count               = local.mongo_desired_count
    desired_min                 = local.mongo_desired_min
    desired_max                 = local.mongo_desired_max
    image_ecr_url               = "mongo"
    image_tag                   = "4.2-bionic"
    #target_group_arn            = dependency.tg.outputs.target_group_arn
    container_name              = "${local.common_tags.Project}--mongodb-${local.common_tags.Environment}"
    retention_in_days           = 7
    port_mapping    = [
        {
            containerPort : 27017,
            hostPort : 27017, 
            protocol : "tcp"
        }
    ]

    volume_name     = "${local.common_tags.Project}--mongodb"
    efs_id          = module.efs.efs_id
    root_directory  = "/"
    container_path  = "/data/db"
    read_only       = false

    ##advanced_options            = true #use to create Unlimits and RuntimePlatform
    operating_system_family     = "LINUX"
    cpu_architecture            = "X86_64"
#    softLimit                   = 4096
 #   hardLimit                   = 8192

    enable_service_discovery        = true
    service_discovery_container_name = "${local.common_tags.Project}-mongodb.${local.common_tags.Environment}.ecs.com"
    service_namespace_name          = "${local.common_tags.Environment}.ecs.com"
    description_namespace           = "used for mongo in project: ${local.common_tags.Project} and environment: ${local.common_tags.Environment}"

   autoScale_daytime                   = false
    cpu_threshold_low = 35
    cpu_threshold_high = 65
    
    task_secret_environment_variables = [ 
#        { name : "SECRET", valueFrom : "secrets_manager_secret_arn" }
    ]

    execution_iam_access = {
        secrets = [
        ]
        kms_cmk = [
        ]
        s3_buckets = [
        ]
    }

    port                    = 80
    protocol                = "HTTP"
    target_type             = "ip"
    health_path             = "/health"
    protocol_healthCheck    = "HTTP"
    matcher                 = "200"
    zone_id                 = module.zone_internal.domain_name_private
    listener_arn            = module.alb_private.alb_listener_arn
  tags = merge(local.common_tags, {
  })   
    depends_on = [ module.rds, module.sg_public, module.alb_public, module.ecs_cluster, module.zone_internal, module.sqs, module.efs ]
}


# Criar um arquivo localmente usando Terraform
resource "local_file" "arquivo" {
  filename = "${path.module}/BulkMigratorConfig.config"
  content  = <<EOT
${{ values.xmlarea }}
EOT
}

resource "aws_s3_object" "addfile" {
  bucket = "qa-auto-exec-config-autos"
  key    = "BulkMigrator/BulkMigratorConfig.config"
  source = local_file.arquivo.filename 
  acl    = "private"
#  etag   = filemd5("BulkMigrator/BulkMigratorConfig.config")  # Força o Terraform a detectar mudanças
}
