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

# --------------------------------------------------------------------------
# Security Groups
# --------------------------------------------------------------------------

resource "aws_security_group" "app-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    # OrderService
    ingress {
        from_port   = 8020
        to_port     = 8020
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # PaymentService
    ingress {
        from_port   = 8030
        to_port     = 8030
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Alloy UI
    ingress {
        from_port   = 12345
        to_port     = 12345
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
        Name = "${var.env_prefix}-app-sg"
    }
}

resource "aws_security_group" "prometheus-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port   = 9090
        to_port     = 9090
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
        Name = "${var.env_prefix}-prometheus-sg"
    }
}

resource "aws_security_group" "tempo-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    # Tempo HTTP API
    ingress {
        from_port   = 3200
        to_port     = 3200
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # OTLP gRPC receiver (from Alloy)
    ingress {
        from_port   = 4317
        to_port     = 4317
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # OTLP HTTP receiver (from Alloy)
    ingress {
        from_port   = 4318
        to_port     = 4318
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
        Name = "${var.env_prefix}-tempo-sg"
    }
}

resource "aws_security_group" "grafana-sg" {
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port   = 3000
        to_port     = 3000
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
        Name = "${var.env_prefix}-grafana-sg"
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

resource "aws_instance" "app" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "t3.small"
    subnet_id                   = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.app-sg.id]
    availability_zone           = var.avail_zone_1
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "App Server"
    }
}

resource "aws_instance" "prometheus" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "t3.small"
    subnet_id                   = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.prometheus-sg.id]
    availability_zone           = var.avail_zone_1
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "Prometheus Server"
    }
}

resource "aws_instance" "tempo" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "t3.small"
    subnet_id                   = aws_subnet.myapp-subnet-2.id
    vpc_security_group_ids      = [aws_security_group.tempo-sg.id]
    availability_zone           = var.avail_zone_2
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "Tempo Server"
    }
}

resource "aws_instance" "grafana" {
    ami                         = data.aws_ami.latest-ubuntu-image.id
    instance_type               = "t3.small"
    subnet_id                   = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids      = [aws_security_group.grafana-sg.id]
    availability_zone           = var.avail_zone_1
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name
    user_data                   = file("entry-script.sh")
    tags = {
        Name = "Grafana Server"
    }
}

resource "aws_key_pair" "ssh-key" {
    key_name   = "server-key"
    public_key = file(var.public_key_location)
}

# --------------------------------------------------------------------------
# Outputs
# --------------------------------------------------------------------------

output "app_public_ip" {
    value = aws_instance.app.public_ip
}

output "prometheus_public_ip" {
    value = aws_instance.prometheus.public_ip
}

output "tempo_public_ip" {
    value = aws_instance.tempo.public_ip
}

output "grafana_public_ip" {
    value = aws_instance.grafana.public_ip
}
