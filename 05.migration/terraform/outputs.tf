output "instance_public_ip" {
  description = "Public IP of the migration instance"
  value       = aws_instance.migration.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the migration instance"
  value       = aws_instance.migration.private_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.migration.id
}

output "ssh_command" {
  description = "SSH command to connect to the migration instance"
  value       = "ssh -i ~/.ssh/migration_key ubuntu@${aws_instance.migration.public_ip}"
}
