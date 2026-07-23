locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dns       = read_terragrunt_config(find_in_parent_folders("dns.hcl"))
  zone_id   = local.dns.locals.dns.zone_id
  zone_name = local.dns.locals.dns.zone_name
  internal  = local.dns.locals.internal.name
  img       	= read_terragrunt_config(find_in_parent_folders("images.hcl"))
  url_mongo	    = local.img.locals.ecr.mongo.url
  tag_mongo	    = local.img.locals.ecr.mongo.tag
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_services_baseline_url_efs" : null
}

dependency "alb" {
  config_path = "../../baseline/alb_mib_private"
}

dependency "cluster" {
  config_path = "../../baseline/cluster_mib"
}

dependency "sg" {
  config_path = "../../baseline/security_groups/sg_mib_services_private"
}

dependency "zone" {
  config_path = "../../baseline/zone_internal"
}

dependency "efs" {
  config_path = "../../extras/efs_mib"
}

dependency "vpc" {
  config_path = "../../baseline/vpc_subnet"
}

inputs = {

    task_environment_variables = [
                {
                    name : "",
                    value: ""
                }
    ]

    rule_hosted_based = {
        rule01 = {
            #target_group_arn = dependency.target_mongodb.outputs.target_group_arn
            priority = 90
            type = "forward"
            host  = ["${local.project}-mongodb-${local.env}.${local.internal}"]
        }
    }

    dns_alias_records = {
        rule01 = {
            name = "${local.project}-mongodb-${local.env}.${local.internal}"
            type = "A"
            alias_name = dependency.alb.outputs.alb_dns_name,
            alias_zone_id  = dependency.alb.outputs.alb_zone_id,
            alias_target_health = true
        }
    }

    prefix_name                 = "${local.project}-mib-mongodb-${local.env}"
    tg_name                     = "${local.project}-mib-mongodb-${local.env}"
    cluster_id                  = dependency.cluster.outputs.ecs_cluster_id
    ecs_cluster_name            = dependency.cluster.outputs.ecs_cluster_name
    vpc_id                      = dependency.vpc.outputs.vpc_id
    public_subnets              = dependency.vpc.outputs.public_subnets
    private_subnets             = dependency.vpc.outputs.private_subnets
    security_group_id           = dependency.sg.outputs.security_group_id
    prefix_name                 = "${local.project}-mib-mongodb-${local.env}"
    service_name                = "${local.project}-mib-mongodb-${local.env}"
    is_public                   = false
    assign_public_ip            = false
    autoScale_resource_usage    = true
    fargate_cpu                 = 512
    fargate_mem                 = 1024
    container_cpu               = 512
    container_mem               = 1024
    container_port              = 27017
    desired_count               = 1
    desired_min                 = 1
    desired_max                 = 2
    ecs_name                    = "${local.project}-mib-mongodb-${local.env}"
    image_ecr_url               = local.url_mongo
    image_tag                   = local.tag_mongo
    #target_group_arn            = dependency.tg.outputs.target_group_arn
    container_name              = "${local.project}-mib-mongodb-${local.env}"
    retention_in_days           = 7
    port_mapping    = [
        {
            containerPort : 27017,
            hostPort : 27017, 
            protocol : "tcp"
        }
    ]

    volume_name     = "${local.project}-mib-mongodb-${local.env}"
    efs_id          = dependency.efs.outputs.efs_id
    root_directory  = "/"
    container_path  = "/data/db"
    read_only       = false

    ##advanced_options            = true #use to create Unlimits and RuntimePlatform
    operating_system_family     = "LINUX"
    cpu_architecture            = "X86_64"
#    softLimit                   = 4096
 #   hardLimit                   = 8192

    enable_service_discovery        = true
    service_discovery_container_name = "${local.project}-mongodb.${local.env}.ecs.com"
    service_namespace_name          = "${local.env}.ecs.com"
    description_namespace           = "used for mongo in project: ${local.project} and environment: ${local.env}"

    autoScale_daytime                   = false
    autoscale_task_weekday_scale_up     = 2
    autoscale_task_weekday_scale_down   = 1
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
    zone_id                 = dependency.zone.outputs.zone_id_private
    listener_arn            = dependency.alb.outputs.alb_listener_arn
    prefix_name             = "${local.project}-mib-mongodb-${local.env}"
    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )    
}