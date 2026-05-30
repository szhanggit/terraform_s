variable "vpc_id" {
  type        = string
  description = "VPC ID where the NAT Gateway will be created"
}

variable "public_subnet_id" {
  type        = string
  description = "The public subnet to host the NAT Gateway"
}

variable "private_route_table_ids" {
  type        = map(string)
  description = "List of route table IDs for private subnets"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}
