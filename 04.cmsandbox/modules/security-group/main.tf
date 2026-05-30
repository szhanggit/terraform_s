resource "aws_security_group" "ecs" {
  name        = "${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ecs-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_self_tcp_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to connect to each other on port 8080"
}

resource "aws_security_group_rule" "ecs_self_grpc_50051" {
  type                     = "ingress"
  from_port                = 50051
  to_port                  = 50051
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to connect to each other on gRPC port"
}

resource "aws_security_group_rule" "ecs_self_nats_cluster" {
  type                     = "ingress"
  from_port                = 6222
  to_port                  = 6222
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to connect to each other on NATS cluster port"
}

resource "aws_security_group_rule" "ecs_self_nats_client" {
  type                     = "ingress"
  from_port                = 4222
  to_port                  = 4222
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to connect to each other on NATS client port"
}

resource "aws_security_group_rule" "ecs_self_nats_monitor" {
  type                     = "ingress"
  from_port                = 8222
  to_port                  = 8222
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to connect to each other on NATS monitor port"
}

resource "aws_security_group_rule" "bastion_to_nats_monitor" {
  type              = "ingress"
  from_port         = 8222
  to_port           = 8222
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "Allow bastion host to access NATS monitor port"
}

resource "aws_security_group_rule" "bastion_to_nats_client" {
  type              = "ingress"
  from_port         = 4222
  to_port           = 4222
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["10.0.0.0/16"]
  description       = "Allow bastion host to access NATS client port"
}


resource "aws_security_group" "efs" {
  name        = "${var.environment}-efs-sg"
  description = "Security Group for EFS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id, aws_security_group.lambda.id,aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-efs-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "lambda" {
  name        = "${var.environment}-lambda-sg"
  description = "Security Group for Lambda functions"
  vpc_id      = var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-lambda-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_self_3593" {
     type                     = "ingress"
     from_port                = 3593
     to_port                  = 3593
     protocol                 = "tcp"
     security_group_id        = aws_security_group.ecs.id
     source_security_group_id = aws_security_group.ecs.id
     description              = "Allow ECS tasks to access Cerbos gRPC (self-reference)"
   }

resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-sg"
  description = "Security Group for Bastion Host"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = var.allow_cidr_blocks
  description       = "Allow SSH access to bastion"
}

resource "aws_security_group" "influxdb" {
  name        = "${var.environment}-influxdb-sg"
  description = "Security Group for InfluxDB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.environment}-influxdb-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_to_influxdb_8086" {
  type                     = "ingress"
  from_port                = 8086
  to_port                  = 8086
  protocol                 = "tcp"
  security_group_id        = aws_security_group.influxdb.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to access InfluxDB"
}

resource "aws_security_group_rule" "bastion_to_influxdb_8086" {
  type                     = "ingress"
  from_port                = 8086
  to_port                  = 8086
  protocol                 = "tcp"
  security_group_id        = aws_security_group.influxdb.id
  source_security_group_id = aws_security_group.bastion.id
  description              = "Allow bastion host to access InfluxDB"
}

resource "aws_security_group_rule" "my_ip_to_influxdb_8086" {
  type              = "ingress"
  from_port         = 8086
  to_port           = 8086
  protocol          = "tcp"
  security_group_id = aws_security_group.influxdb.id
  cidr_blocks       = ["47.203.2.117/32"]
  description       = "Allow your IP to access InfluxDB UI"
}

resource "aws_security_group_rule" "ecs_to_influxdb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.influxdb.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to access InfluxDB HTTPS API"
}



resource "aws_security_group_rule" "vpn_udp_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow OpenVPN UDP traffic"
}

resource "aws_security_group_rule" "vpn_tcp_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow OpenVPN TCP traffic (alternative port)"
}

resource "aws_security_group_rule" "vpn_udp_1194_ecs" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "udp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow OpenVPN UDP traffic to ECS"
}

resource "aws_security_group_rule" "vpn_tcp_443_ecs" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow OpenVPN TCP traffic to ECS (alternative port)"
}


resource "aws_security_group" "mysql" {
  name        = "${var.environment}-mysql-sg"
  description = "Security Group for MySQL"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-mysql-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_to_mysql_3306" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mysql.id
  source_security_group_id = aws_security_group.ecs.id
  description              = "Allow ECS tasks to access MySQL"
}

resource "aws_security_group_rule" "bastion_to_mysql_3306" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mysql.id
  source_security_group_id = aws_security_group.bastion.id
  description              = "Allow bastion host to access MySQL"
}

resource "aws_security_group_rule" "ip_to_mysql_3306" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.mysql.id
  cidr_blocks       = var.allow_cidr_blocks
  description       = "Allow specific IP Addresses to access MySQL"
}

resource "aws_security_group_rule" "ip_to_ecs" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  cidr_blocks              = var.allow_cidr_blocks
  description              = "Allow specific IP Addresses to access ECS"
}