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
    name            = "${local.project}-codedeploy-${local.env}"
    create_policy  = true
    policy_description = "Allow codedeploy access ECR ${local.project} ${local.env} repos, s3 and codeploy operations"
    policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "terraform0"
          Effect = "Allow"
          Action = [
            "codedeploy:CreateDeployment",
            "codedeploy:Get*",
            "codedeploy:RegisterApplicationRevision",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken",
            "ecr:UploadLayerPart",
            "ecr:PutImage",
            "s3:PutObject",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:InitiateLayerUpload",
            "ecs:Update*",
            "ecr:BatchCheckLayerAvailability"            
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