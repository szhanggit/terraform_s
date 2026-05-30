# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "cerbos_policies_bucket_name" {
  value = aws_s3_bucket.cerbos_policies.bucket
  description = "Cerbos policies S3 bucket name"
}

output "cerbos_config_bucket_name" {
  value = aws_s3_bucket.cerbos_config.bucket
  description = "Cerbos configuration S3 bucket name"
}

output "influx_config_bucket_name" {
  value = aws_s3_bucket.influx_config.bucket
  description = "InfluxDB configuration S3 bucket name"
}

output "nats_config_bucket_name" {
  value = aws_s3_bucket.nats_config.bucket
  description = "NATS configuration S3 bucket name"
}

output "telegraf_config_bucket_name" {
  value = aws_s3_bucket.telegraf_config.bucket
  description = "Telegraf configuration S3 bucket name"
}

output "telegraf_certificates_bucket_name" {
  value = aws_s3_bucket.telegraf_certificates.bucket
  description = "Telegraf certificates S3 bucket name"
}

output "utility_obol_schema_bucket_name" {
  value = aws_s3_bucket.utility_obol_schema.bucket
  description = "Utility Obol Schema S3 bucket name"
}

output "ra_physical_config_bucket_name" {
  value = aws_s3_bucket.ra_physical_config.bucket
  description = "RA Physical Config S3 bucket name"
}

output "ra_user_config_bucket_name" {
  value = aws_s3_bucket.ra_user_config.bucket
  description = "RA User Config S3 bucket name"
}