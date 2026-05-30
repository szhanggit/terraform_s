# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    Environment = var.environment
  }
}

# Private Subnets (2 AZs)
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = "private-a"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name        = "private-b"
    Environment = var.environment
  }
}

# Public Subnets (2 AZs)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name        = "public-a"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name        = "public-b"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_b.id
  ]
  
  tags = {
    Name        = "s3-vpc-endpoint"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id
  tags = { 
    Name = "private-a"
    Environment = var.environment
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id
  tags = { 
    Name = "private-b"
    Environment = var.environment
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

locals {
  public_subnets = {
    public_a = aws_subnet.public_a.id
    public_b = aws_subnet.public_b.id
  }
  
  private_subnets = {
    private_a = aws_subnet.private_a.id
    private_b = aws_subnet.private_b.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with their route tables
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}
