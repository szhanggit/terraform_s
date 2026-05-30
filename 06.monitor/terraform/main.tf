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
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block_1
    availability_zone = var.avail_zone_1
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_subnet" "myapp-subnet-2" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block_2
    availability_zone = var.avail_zone_2
    tags = {
        Name = "${var.env_prefix}-subnet-2"
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

resource "aws_route_table_association" "rtb-subnet-2" {
    subnet_id      = aws_subnet.myapp-subnet-2.id
    route_table_id = aws_route_table.main-rtb.id
}

resource "aws_security_group" "prometheus-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 9090
        to_port = 9090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-prometheus-sg"
    }
}

resource "aws_security_group" "app-server-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 9100
        to_port = 9100
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.env_prefix}-app-server-sg"
    }
}   

data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

output "aws_ami_id" {
    value = data.aws_ami.latest-ubuntu-image.id
}

output "prometheus_public_ip" {
    value = aws_instance.prometheus.public_ip
}

output "app_server_public_ip" {
    value = aws_instance.app-server.public_ip
}

resource "aws_instance" "prometheus" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = "t3.small"

    subnet_id = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.prometheus-sg.id]
    availability_zone = var.avail_zone_1

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    user_data = file("entry-script.sh")

    tags = {
        Name = "Prometheus"
    }
}

resource "aws_instance" "app-server" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = "t3.small"

    subnet_id = aws_subnet.myapp-subnet-2.id
    vpc_security_group_ids = [aws_security_group.app-server-sg.id]
    availability_zone = var.avail_zone_2

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    user_data = file("entry-script.sh")

    tags = {
        Name = "App Server"
    }
}   

resource "aws_key_pair" "ssh-key" {
    key_name = "server-key"
    public_key = file(var.public_key_location)
}