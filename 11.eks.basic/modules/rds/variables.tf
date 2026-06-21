variable "vpc_id" {
  description = "VPC ID of the EKS cluster's VPC, used for the RDS security group"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs of the EKS cluster's VPC, for the DB subnet group"
  type        = list(string)
}

variable "db_security_group_name" {
  description = "Name of the security group allowing inbound MySQL/Aurora access"
  type        = string
  default     = "eks_rds_db_sg"
}

variable "db_subnet_group_name" {
  description = "Name of the RDS DB subnet group"
  type        = string
  default     = "eks-rds-db-subnetgroup"
}

variable "db_instance_identifier" {
  description = "DB instance identifier"
  type        = string
  default     = "usermgmtdb"
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.4.8"
}

variable "db_instance_class" {
  description = "DB instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage (GiB)"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "db_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "db_master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = true
}
