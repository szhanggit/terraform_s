terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "stevenz"
}

# ---------------------------------------------------------------------------
# Data sources — look up existing shared infrastructure
# ---------------------------------------------------------------------------

resource "aws_vpc" "dev" {
    cidr_block = "10.0.0.0/16"
    tags = {
        vpc_env = "dev"
        Name = var.vpc_name
    }
}

resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.dev.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ca-central-1a"
    tags = {
        Name = "public_a"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name        = "migration-igw"
    Environment = "dev"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "migration-public-rt"
    Environment = "dev"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs" {
  name        = "ecs-sg"
  vpc_id      = aws_vpc.dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name        = "ecs-sg"
    Environment = "dev"
  }
}

# ---------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------

resource "aws_security_group" "migration_ssh" {
  name        = "migration-ssh-sg"
  description = "Allow SSH from anywhere to the migration instance"
  vpc_id      = aws_vpc.dev.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name        = "migration-ssh-sg"
    Environment = "dev"
  }
}

resource "aws_key_pair" "migration" {
  key_name   = "migration-key"
  public_key = file(var.ssh_public_key_path)

  tags = {
    Name        = "migration-key"
    Environment = "dev"
  }
}

resource "aws_instance" "migration" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.ecs.id,
    aws_security_group.migration_ssh.id,
  ]
  key_name = aws_key_pair.migration.key_name

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "migration-instance"
    Environment = "dev"
  }
}
