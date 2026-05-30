output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = [
    module.vpc.public_subnet_ids[0],
    module.vpc.public_subnet_ids[1],
  ]
}

output "private_subnet_ids" {
  value = [
    module.vpc.private_subnet_ids[0],
    module.vpc.private_subnet_ids[1],
  ]
}

output "lambda_security_group_id" {
  value = module.security_group.lambda_security_group_id
}
output "ecs_security_group_id" {
  value = module.security_group.ecs_security_group_id
}
output "efs_security_group_id" {
  value = module.security_group.efs_security_group_id
}

output "mysql_security_group_id" {
  value = module.security_group.mysql_security_group_id
}

output efs_policies_access_point_arn {
  value = module.efs.policies_access_point_arn
}

output efs_policies_access_point_id {
  value = module.efs.policies_access_point_id
}

output efs_config_access_point_arn {
  value = module.efs.config_access_point_arn
}

output "efs_config_access_point_id" {
  value = module.efs.config_access_point_id
}

output "efs_nats_config_access_point_id" {
  value = module.efs.nats_config_access_point_id
}

output "efs_nats_config_access_point_arn" {
  value = module.efs.nats_config_access_point_arn
}

output "efs_telegraf_config_access_point_id" {
  value = module.efs.telegraf_config_access_point_id
}

output "efs_telegraf_certificates_access_point_arn" {
  value = module.efs.telegraf_certificates_access_point_arn
}

output "efs_telegraf_certificates_access_point_id" {
  value = module.efs.telegraf_certificates_access_point_id
}

output "ra_physical_config_access_point_id" {
  value = module.efs.ra_physical_config_access_point_id
}

output "ra_physical_config_access_point_arn" {
  value = module.efs.ra_physical_config_access_point_arn
}

output "ra_user_config_efs_access_point_id" {
  value = module.efs.ra_user_config_access_point_id
}

output "ra_user_config_efs_access_point_arn" {
  value = module.efs.ra_user_config_access_point_arn
}

output "efs_id" {
  value = module.efs.id
}

output "efs_vpc_endpoint_id" {
  description = "EFS VPC Endpoint ID"
  value       = aws_vpc_endpoint.efs.id
}

output "efs_vpc_endpoint_dns_entry" {
  description = "DNS name for the EFS VPC endpoint"
  value       = aws_vpc_endpoint.efs.dns_entry
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.nat_gateway.nat_gateway_id
}

output "ecs_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = module.roles.ecs_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = module.roles.ecs_task_role_arn
}

output "utility_obol_schema_bucket_name" {
  value       = module.s3.utility_obol_schema_bucket_name
  description = "Utility Obol Schema S3 bucket name"
}

output "cerbos_config_bucket_name" {
  value       = module.s3.cerbos_config_bucket_name
  description = "Cerbos configuration S3 bucket name"
}

output "cerbos_policies_bucket_name" {
  value       = module.s3.cerbos_policies_bucket_name
  description = "Cerbos policies S3 bucket name"
}

output "influx_config_bucket_name" {
  value       = module.s3.influx_config_bucket_name
  description = "InfluxDB configuration S3 bucket name"
}

output "fortress_power_private_dns_namespace_arn" {
  value       = aws_service_discovery_private_dns_namespace.fortress_power_private_dns_namespace.arn
  description = "ARN of the shared Service Connect namespace for Fortress Power"
}

output "fortress_power_private_dns_namespace_id" {
  value       = aws_service_discovery_private_dns_namespace.fortress_power_private_dns_namespace.id
  description = "ID of the shared Service Connect namespace for Fortress Power"
}