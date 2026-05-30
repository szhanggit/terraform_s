variable "creation_token" {
  description = "Creation token for EFS"
  type        = string
}

variable "name" {
  description = "Name for EFS resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "posix_user_gid" {
  description = "POSIX user GID"
  type        = number
  default     = 1000
}

variable "posix_user_uid" {
  description = "POSIX user UID"
  type        = number
  default     = 1000
}

variable "efs_security_group_id" {
  description = "EFS security group ID"
  type        = string
}