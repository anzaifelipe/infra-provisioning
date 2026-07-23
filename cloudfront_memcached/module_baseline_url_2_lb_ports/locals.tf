locals {
    rule_hosted_based = {
        for rule in keys(var.rule_hosted_based):
            rule => lookup(var.rule_hosted_based, rule)
    }
    dns_record_items = {
        for record in keys(var.dns_record_items):
            record => lookup(var.dns_record_items, record)
    }

    dns_alias_record_items = {
        for record in keys(var.dns_alias_records):
            record => lookup(var.dns_alias_records, record)
    }

    dns_weighted_record_items = {
        for record in keys(var.dns_weighted_record_items):
            record => lookup(var.dns_weighted_record_items, record)
    }
  # Find all secret ARNs and output as a list
  execution_iam_secrets = try(
    flatten([
      for permission_type, permission_targets in var.execution_iam_access : [
        for secret in permission_targets : "${secret}*"
      ]
      if permission_type == "secrets"
    ]),
    # If nothing provided, default to empty set
    [],
  )

  # Final all S3 bucket ARNs and output as list
  execution_iam_s3_buckets = try(
    flatten([
      for permission_type, permission_targets in var.execution_iam_access : permission_targets if permission_type == "s3_buckets"
    ]),
    # If nothing provided, default to empty set
    [],
  )

  # Final all S3 bucket ARNs and output as list for object access
  execution_iam_s3_buckets_object_access = try(
    flatten(
      [
        for buckets in local.execution_iam_s3_buckets : "${buckets}/*"
      ]
    ),
    # If nothing provided, default to empty set
    [],
  )

  # Find all KMS CMK ARNs passed to module and output as a list
  execution_iam_kms_cmk = try(
    flatten([
      for permission_type, permission_targets in var.execution_iam_access : [
        for kms_cmk in permission_targets : kms_cmk
      ]
      if permission_type == "kms_cmk"
    ]),
    # If nothing provided, default to empty set
    [],
  )
}