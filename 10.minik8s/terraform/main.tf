provider "aws" {
    region  = "ca-central-1"
    profile = "stevenz"
}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id            = aws_vpc.myapp-vpc.id
    cidr_block        = var.subnet_cidr_block_1
    availability_zone = var.avail_zone_1
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

resource "aws_route_table" "main-rtb" {
    vpc_id = aws_vpc.myapp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name = "${var.env_prefix}-rtb"
    }
}

resource "aws_route_table_association" "rtb-subnet-1" {
    subnet_id      = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.main-rtb.id
}

# --------------------------------------------------------------------------
# Security Groups
# --------------------------------------------------------------------------

resource "aws_security_group" "master-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    # Kubernetes API Server
    ingress {
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # All intra-VPC traffic (kubelet, etcd, flannel VXLAN, etc.)
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr_block]
    }

    # NodePort range
    ingress {
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-master-sg"
    }
}

resource "aws_security_group" "node-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    # All intra-VPC traffic (kubelet, flannel VXLAN, etc.)
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.vpc_cidr_block]
    }

    # NodePort range
    ingress {
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-node-sg"
    }
}

# --------------------------------------------------------------------------
# AMI lookup
# --------------------------------------------------------------------------

data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners      = ["099720109477"]
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

output "aws_ami_id" {
    value = data.aws_ami.latest-ubuntu-image.id
}

# --------------------------------------------------------------------------
# EC2 Instances
# --------------------------------------------------------------------------

resource "aws_instance" "k8s-master" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "m7i-flex.large"
    subnet_id                   = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.master-sg.id]
    availability_zone           = var.avail_zone_1
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "K8s Master"
    }
}

resource "aws_instance" "k8s-node" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "t3.small"
    subnet_id                   = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.node-sg.id]
    availability_zone           = var.avail_zone_1
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "K8s Node"
    }
}

resource "aws_key_pair" "ssh-key" {
    key_name   = "k8s-server-key"
    public_key = file(var.public_key_location)
}

# --------------------------------------------------------------------------
# Outputs
# --------------------------------------------------------------------------

output "master_public_ip" {
    value = aws_instance.k8s-master.public_ip
}

output "master_private_ip" {
    value = aws_instance.k8s-master.private_ip
}

output "node_public_ip" {
    value = aws_instance.k8s-node.public_ip
}
