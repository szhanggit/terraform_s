output "id" {
  value = aws_efs_file_system.this.id
}

output "file_system_arn" {
  value = aws_efs_file_system.this.arn
}

output "config_access_point_id" {
  value = aws_efs_access_point.config.id
}

output "config_access_point_arn" {
  value = aws_efs_access_point.config.arn
}

output "policies_access_point_id" {
  value = aws_efs_access_point.policies.id
}

output "policies_access_point_arn" {
  value = aws_efs_access_point.policies.arn
}

output "nats_config_access_point_id" {
  value = aws_efs_access_point.nats_config.id
  description = "value of the EFS access point ID for NATS configuration"
}

output "nats_config_access_point_arn" {
  value = aws_efs_access_point.nats_config.arn
  description = "value of the EFS access point ARN for NATS configuration"
}

output "telegraf_config_access_point_id" {
  value = aws_efs_access_point.telegraf_config.id
  description = "value of the EFS access point ID for Telegraf configuration"
}

output "telegraf_config_access_point_arn" {
  value = aws_efs_access_point.telegraf_config.arn
  description = "value of the EFS access point ARN for Telegraf configuration"
}

output "telegraf_certificates_access_point_arn" {
  value = aws_efs_access_point.telegraf_certificates.arn
  description = "value of the EFS access point ARN for Telegraf certificates"
}

output "telegraf_certificates_access_point_id" {
  value = aws_efs_access_point.telegraf_certificates.id
  description = "value of the EFS access point ID for Telegraf certificates"
}

output "ra_physical_config_access_point_id" {
  value = aws_efs_access_point.ra_physical.id
  description = "value of the EFS access point ID for RA Physical configuration"
}

output "ra_physical_config_access_point_arn" {
  value = aws_efs_access_point.ra_physical.arn
  description = "value of the EFS access point ARN for RA Physical configuration"
}

output "ra_user_config_access_point_id" {
  value = aws_efs_access_point.ra_user.id
  description = "value of the EFS access point ID for RA User configuration"
}

output "ra_user_config_access_point_arn" {
  value = aws_efs_access_point.ra_user.arn
  description = "value of the EFS access point ARN for RA User configuration"
}