variable "environment" {
  description = "The environment for which the Lambda function is being created (e.g., dev, staging, prod)."
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string  
}

variable "function_description" {
  description = "The description of the Lambda function."
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the Lambda function."
  type        = list(string)
}

variable "efs_file_system_arn" {
  description = "ARN of the EFS file system to mount in the Lambda function."
  type        = string
}

variable "efs_access_point_arn" {
  description = "ARN of the EFS access point to use for the Lambda function."
  type        = string
  
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket where Cerbos configuration files are stored."
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for Lambda to access EFS"
  type        = string
}

variable "lambda_zip_path" {
  type = string
}