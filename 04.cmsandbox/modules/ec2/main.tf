resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami_id  # Amazon Linux 2 or Ubuntu AMI
  instance_type          = var.bastion_instance_type
  subnet_id              = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.bastion_security_group_id]
  key_name               = var.key_pair_name

  tags = {
    Name = var.host_name
    Environment = var.environment
  }
}