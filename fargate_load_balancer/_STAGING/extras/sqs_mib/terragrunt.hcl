locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dest    = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region  = local.dest.locals.region
  account = local.dest.locals.account_id
  users   = read_terragrunt_config(find_in_parent_folders("user_bucket.hcl"))
  user    = local.users.locals.user
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_sqs" : null
}

inputs = {
    name                        = "${local.project}-mib-${local.env}.fifo"
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
                            AWS = "arn:aws:iam::${local.account}:user/${local.user}"
                        }
                        Resource  = "arn:aws:${local.region}:${local.account}:${local.project}-mib-${local.env}.fifo"
                        Sid       = "__owner_statement"
                    },
                ]
                Version   = "2008-10-17"
            }
        )

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}