resource "aws_efs_mount_target" "alpha" {
  count           = length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = element(concat(var.subnets, [""]), count.index)
  security_groups = var.security_groups_id
}