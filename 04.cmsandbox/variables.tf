variable "region" {
  description = "The AWS region where the infrastructure will be deployed."
  type        = string
  
}

variable "environment" {
  description = "The environment for which the infrastructure is being created (e.g., dev, staging, prod)."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to create."
  type        = string
}

variable "cerbos_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing Cerbos configuration."
  type        = string
}

variable "cerbos_policies_bucket_name" {
  description = "The name of the S3 bucket to create for storing Cerbos policies."
  type        = string
}

variable "influx_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing InfluxDB configuration."
  type        = string
}

variable "nats_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing NATS configuration."
  type        = string
}

variable "telegraf_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing Telegraf configuration."
  type        = string
}

variable "telegraf_certificates_bucket_name" {
  description = "The name of the S3 bucket to create for storing Telegraf certificates."
  type        = string
}

variable "utility_obol_schema_bucket_name" {
  description = "The name of the S3 bucket to create for storing Utility Obol Schema."
  type        = string
}

variable "ra_physical_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing RA Physical configuration."
  type        = string
}

variable "ra_user_config_bucket_name" {
  description = "The name of the S3 bucket to create for storing RA User configuration."
  type        = string
}