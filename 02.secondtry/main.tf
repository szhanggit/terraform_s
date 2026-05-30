provider "aws" {
    region = "ca-central-1"
    access_key = ""
    secret_key = ""
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

resource "aws_vpc" "dev-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        vpc_env = "dev"
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

data "aws_vpc" "default" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.default.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "ca-central-1b"
    tags = {
        Name = "subnet-2-dev"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}