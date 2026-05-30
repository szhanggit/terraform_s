provider "aws" {
    region = "ca-central-1"
    access_key = ""
    secret_key = ""
}

resource "aws_vpc" "dev-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        vpc_env = "dev"
        Name = var.environment
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = "ca-central-1a"
    tags = {
        Name = "subnet-1-dev"
    }
}

variable "subnet_cidr_block" {
  type        = string
  default     = "10.0.10.0/24"
  description = "subnet cidr block"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc cidr block"
}

variable "environment" {
    description = "deployment environment"
}

