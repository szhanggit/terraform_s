variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eksdemo1"
}

variable "region" {
  description = "AWS region for the EKS cluster"
  type        = string
  default     = "ca-central-1"
}

variable "azs" {
  description = "Availability zones for the cluster's public subnets"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.31"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the EKS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets, one per AZ in var.azs"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets, one per AZ in var.azs"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "nodegroup_name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = "eksdemo1-ng-public1"
}

variable "node_instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = "t3.small"
}

variable "node_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 4
}

variable "node_volume_size" {
  description = "Root EBS volume size (GiB) for each node"
  type        = number
  default     = 20
}

variable "ssh_public_key_name" {
  description = "Name of an existing EC2 key pair to enable SSH access to nodes"
  type        = string
  default     = "kube-demo"
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier"
  type        = string
  default     = "usermgmtdb"
}

variable "db_engine_version" {
  description = "RDS MySQL engine version"
  type        = string
  default     = "8.4.8"
}

variable "db_instance_class" {
  description = "RDS DB instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage (GiB)"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp2"
}

variable "db_master_username" {
  description = "Master username for the RDS database"
  type        = string
  default     = "dbadmin"
}

variable "db_master_password" {
  description = "Master password for the RDS database. Set this in a local-only tfvars file (e.g. secrets.auto.tfvars), never commit it."
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "RDS database port"
  type        = number
  default     = 3306
}

variable "db_publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
  type        = bool
  default     = true
}
