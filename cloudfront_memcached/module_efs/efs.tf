resource "aws_efs_file_system" "efs" {
  creation_token   = var.name
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = var.encrypted
  lifecycle_policy {
    transition_to_ia = var.transition_to_ia
  }

  tags = merge(
    {
      "Name" = format(
        "${var.name}"
      )
    },
    var.tags,
  )
}
