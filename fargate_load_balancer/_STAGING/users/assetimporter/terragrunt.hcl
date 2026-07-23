locals {
  enabled = true
  common  = read_terragrunt_config(find_in_parent_folders("tags.hcl"))
  env     = local.common.locals.Environment
  project = local.common.locals.Project
  dns       = read_terragrunt_config(find_in_parent_folders("dns.hcl"))
  zone_id   = local.dns.locals.dns.zone_id
  zone_name = local.dns.locals.dns.zone_name
}

include {
    path = find_in_parent_folders()
}

terraform {
    source = local.enabled ? "../../../module_iam_user" : null
}

inputs = {
    name            = "${local.project}-assetimporter-${local.env}"
    create_policy  = true
    policy_description = "Allow full access to the bucket ${local.project} assetimporter ${local.env} and general S3 listing operations"
    policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "terraform0"
          Effect = "Allow"
          Action = [
            "s3:GetAccessPoint",
            "s3:PutAccountPublicAccessBlock",
            "s3:GetAccountPublicAccessBlock",
            "s3:ListAccessPoints",
            "s3:ListJobs",
            "s3:CreateJob",
            "s3:ListBucket",
            "s3:GetBucketLocation",
            "s3:ListAllMyBuckets"
          ]
          Resource = "arn:aws:s3:::*"
        },
        {
          Sid    = "terraform1"
          Effect = "Allow"
          Action = "s3:*"
          Resource = [
            "arn:aws:s3:::${local.project}-remote-folder-tef-${local.env}",
            "arn:aws:s3:::${local.project}-remote-folder-tef-${local.env}/*",
            "arn:aws:s3:::${local.project}-importer-sqs-${local.env}",
            "arn:aws:s3:::${local.project}-importer-sqs-${local.env}/*",
          ]
        },
        {
          Sid    = "terraform2"
          Effect = "Allow"
          Action = [
            "sqs:GetQueueAttributes",
            "sqs:GetQueueUrl",
            "sqs:ListDeadLetterSourceQueues",
            "sqs:ListQueues",
            "sqs:ReceiveMessage",
            "sqs:SendMessage",
            "sqs:CreateQueue",
            "sqs:DeleteMessage",
            "sqs:PurgeQueue",
            "sqs:RemovePermission",
            "sqs:SetQueueAttributes",
            "sqs:TagQueue",
            "sqs:UntagQueue"
          ]          
          Resource = "*"
        }
      ]
    })

    tags = merge(
      local.common.locals,
      {
        TerragruntPath  = path_relative_to_include()
      }
    )
}  