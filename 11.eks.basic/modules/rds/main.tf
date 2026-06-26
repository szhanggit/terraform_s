# Security group allowing inbound MySQL/Aurora (3306) access for the RDS database.
# No egress block is declared so AWS's default allow-all-outbound rule applies.
resource "aws_security_group" "eks_rds_db_sg" {
  name        = var.db_security_group_name
  description = "Allow access for RDS Database on Port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow access for RDS Database on Port 3306"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.db_security_group_name
  }
}

resource "aws_db_subnet_group" "eks_rds_db_subnetgroup" {
  name        = var.db_subnet_group_name
  description = "EKS RDS DB Subnet Group"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

resource "aws_db_instance" "usermgmtdb" {
  identifier     = var.db_instance_identifier
  engine         = "mysql"
  engine_version = var.db_engine_version

  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type

  username = var.db_master_username
  password = var.db_master_password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.eks_rds_db_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.eks_rds_db_sg.id]
  publicly_accessible    = var.db_publicly_accessible
  multi_az               = false

  # Disabled so a destroy never has to wait behind a backup in progress -
  # this is a disposable study environment, not something needing PITR.
  backup_retention_period = 0

  skip_final_snapshot = true
}
