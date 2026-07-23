/*#######======================================================================================================
------------------IAM role for ECS
======================================================================================================#######*/

# Create new IAM role for execution policy to use
resource "aws_iam_role" "ExecutionRole" {
  name               = "${var.service_name}ExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.task_execution_role.json

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-${var.service_name}-iam-ecs"
      )
    },
    var.tags,
  )
}

# Link to AWS-managed policy - AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "ExecutionRole_to_ecsTaskExecutionRole" {
  role       = aws_iam_role.ExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Construct the secrets policy
data "aws_iam_policy_document" "ecs_secrets_access" {
  count = local.execution_iam_secrets == [] ? 0 : 1
  statement {
    sid = "${var.service_name}EcsSecretAccess"
    #effect = "Allow"
    resources = local.execution_iam_secrets
    actions = [
      "secretsmanager:GetSecretValue",
    ]
  }
}

# Build role policy using data, link to role
resource "aws_iam_role_policy" "ecs_secrets_access_role_policy" {
  count  = local.execution_iam_secrets == [] ? 0 : 1
  name   = "${var.service_name}EcsSecretExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.ecs_secrets_access[0].json
}

# Construct the S3 bucket list policy
data "aws_iam_policy_document" "s3_bucket_list_access" {
  count = local.execution_iam_s3_buckets == [] ? 0 : 1
  statement {
    sid       = "S3ListBucketAccess"
    effect    = "Allow"
    resources = local.execution_iam_s3_buckets
    actions = [
      "s3:ListBucket",
    ]
  }
}

# Build role policy using data, link to role
resource "aws_iam_role_policy" "ecs_s3_bucket_list_access_role_policy" {
  count  = local.execution_iam_s3_buckets == [] ? 0 : 1
  name   = "${var.service_name}EcsS3BucketListExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.s3_bucket_list_access[0].json
}

# Construct the S3 bucket object policy
data "aws_iam_policy_document" "s3_bucket_object_access" {
  count = local.execution_iam_s3_buckets_object_access == [] ? 0 : 1
  statement {
    sid       = "S3BucketObjectAccess"
    effect    = "Allow"
    resources = local.execution_iam_s3_buckets_object_access
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
  }
}

# Build role policy using data, link to role
resource "aws_iam_role_policy" "ecs_s3_bucket_object_access_role_policy" {
  count  = local.execution_iam_s3_buckets_object_access == [] ? 0 : 1
  name   = "${var.service_name}EcsS3BucketObjectAccessExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.s3_bucket_object_access[0].json
}

# Construct the S3 bucket object policy
data "aws_iam_policy_document" "kms_cmk_access" {
  count = local.execution_iam_kms_cmk == [] ? 0 : 1
  statement {
    sid       = "KmsCmkAccess"
    effect    = "Allow"
    resources = local.execution_iam_kms_cmk
    actions = [
      "kms:Decrypt"
    ]
  }
}

# Build role policy using data, link to role
resource "aws_iam_role_policy" "ecs_kms_cmk_access_role_policy" {
  count  = local.execution_iam_kms_cmk == [] ? 0 : 1
  name   = "${var.service_name}EcsKmsCmkAccessExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.kms_cmk_access[0].json
}

# Construct the ECS Exec SSM policy (Only if enable_exec is true)
data "aws_iam_policy_document" "ecs_exec_access" {
  count = var.enable_exec ? 1 : 0
  
  statement {
    sid    = "EcsExecSSMAccess"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

# Build role policy using data, link to role conditionally
resource "aws_iam_role_policy" "ecs_exec_access_role_policy" {
  count  = var.enable_exec ? 1 : 0
  name   = "${var.service_name}EcsExecExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.ecs_exec_access[0].json
}

# Capture o ID da conta AWS (Adicione apenas se você já não tiver isso no seu código)
data "aws_caller_identity" "current" {}

# 1. Construct the EFS Access Point policy (Conditional)
data "aws_iam_policy_document" "efs_access_point_policy" {
  count = var.access_point_id != null ? 1 : 0

  statement {
    sid    = "EfsAccessPointMountAccess"
    effect = "Allow"
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite"
      # "elasticfilesystem:ClientRootAccess" # Descomente se o seu container precisar de permissão de root dentro do volume
    ]
    
    # ARN do File System EFS
    resources = [
      "arn:aws:elasticfilesystem:${data.aws_region.current_region.name}:${data.aws_caller_identity.current.account_id}:file-system/${var.efs_id}"
    ]

    # Condição que exige o uso específico deste Access Point
    condition {
      test     = "StringEquals"
      variable = "elasticfilesystem:AccessPointArn"
      values = [
        "arn:aws:elasticfilesystem:${data.aws_region.current_region.name}:${data.aws_caller_identity.current.account_id}:access-point/${var.access_point_id}"
      ]
    }
  }
}

# 2. Build role policy using data, link to role conditionally
resource "aws_iam_role_policy" "ecs_efs_access_point_role_policy" {
  count  = var.access_point_id != null ? 1 : 0
  name   = "${var.service_name}EfsAccessPointExecutionRolePolicy"
  role   = aws_iam_role.ExecutionRole.id
  policy = data.aws_iam_policy_document.efs_access_point_policy[0].json
}