output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "efs_security_group_id" {
  value = aws_security_group.efs.id
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda.id
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
  
}

output "influx_security_group_id" {
  value = aws_security_group.influxdb.id
}

output "mysql_security_group_id" {
  value = aws_security_group.mysql.id
}