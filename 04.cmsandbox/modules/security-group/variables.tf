variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "allow_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to allow access to the security group"
}