output "db_security_group_id" {
  value = aws_security_group.eks_rds_db_sg.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.eks_rds_db_subnetgroup.name
}

output "db_instance_endpoint" {
  value = aws_db_instance.usermgmtdb.endpoint
}

output "db_instance_address" {
  value = aws_db_instance.usermgmtdb.address
}

output "db_instance_port" {
  value = aws_db_instance.usermgmtdb.port
}
