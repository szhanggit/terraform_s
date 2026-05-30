variable "environment" {
    description = "The environment for the resources (e.g., dev, staging, prod)."
}

variable "host_name" {
    description = "The name for the bastion host."
}

variable "public_subnet_id" {
    description = "The ID of the public subnet for the NAT gateway."
}
variable "bastion_ami_id" {
    default = "ami-09cd9fdbf26acc6b4"
    description = "The AMI ID for the bastion host."
}

variable "bastion_instance_type" { 
    default = "t3.micro" 
    description = "The instance type for the bastion host." 
}
variable "key_pair_name" {
    description = "AWS EC2 key pair name (create once in root and pass the same value to all bastion modules)."
    type        = string
}

variable "bastion_security_group_id" {
    description = "The security group ID for the bastion host."
    type        = string
}