/*#######################
SECURITY GROUP SESSION
########################*/

output "rds_security_group_name" {
  description = "Name of Security Group"
  value       = module.sg_rds.security_group_name
}