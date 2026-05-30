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
