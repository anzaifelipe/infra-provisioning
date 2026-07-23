output "efs_id" {
  description = "ID of the EFS"
  value       = aws_efs_file_system.efs.id
}

output "efs_arn" {
  description = "EFS Identify"
  value       = aws_efs_file_system.efs.arn
}

output "dns_name" {
  description = "The DNS name for the filesystem per [documented convention](http://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-cmd-dns-name.html)"
  value       = aws_efs_file_system.efs.dns_name
}

output "size_in_bytes" {
  description = "The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time"
  value       = aws_efs_file_system.efs.size_in_bytes
}