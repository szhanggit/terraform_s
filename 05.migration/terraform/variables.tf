variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "environment" {
  description = "Environment name (must match shared infra tags)"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "Name tag of the existing VPC"
  type        = string
  default     = "keystone-v2-dev-vpc"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 80
}

variable "ami_id" {
  description = "Ubuntu Server 24.04 LTS (HVM), SSD Volume Type."
  type        = string
  default     = "ami-024208b0e77830ebe"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for the migration instance"
  type        = string
  default     = "~/.ssh/migration_key.pub"
}
