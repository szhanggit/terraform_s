terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"  # Adjust this based on AWS release notes
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

module "vpc" {
  source = "./modules/vpc"
  region = var.region
  environment = var.environment
  vpc_name = var.vpc_name
}

module "security_group" {
  source      = "./modules/security-group"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  allow_cidr_blocks = ["0.0.0.0/0"]
  depends_on = [ module.vpc ]
}

resource "aws_service_discovery_private_dns_namespace" "fortress_power_private_dns_namespace" {
  name        = "fortress-power.local"  # Shared domain for all services
  vpc         = module.vpc.vpc_id
  description = "Shared Service Connect namespace across clusters"
}

module "s3" {
  source      = "./modules/s3"
  environment                  = var.environment
  cerbos_config_bucket_name    = var.cerbos_config_bucket_name
  cerbos_policies_bucket_name  = var.cerbos_policies_bucket_name
  influx_config_bucket_name    = var.influx_config_bucket_name
  nats_config_bucket_name      = var.nats_config_bucket_name
  telegraf_config_bucket_name  = var.telegraf_config_bucket_name
  telegraf_certificates_bucket_name = var.telegraf_certificates_bucket_name
  utility_obol_schema_bucket_name = var.utility_obol_schema_bucket_name
  ra_physical_config_bucket_name = var.ra_physical_config_bucket_name
  ra_user_config_bucket_name = var.ra_user_config_bucket_name

  depends_on = [ module.security_group ]
}

module "efs" {
  source = "./modules/efs"
  creation_token           = "configuration-${var.environment}-efs"
  name                     = "configuration-${var.environment}-efs"
  environment              = var.environment
  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.vpc.private_subnet_ids
  efs_security_group_id    = module.security_group.efs_security_group_id
}

module "lambda_policy_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_cerbos_policies_to_efs"
  function_description = "Lambda function to load Cerbos policies to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.policies_access_point_arn
  s3_bucket_name = module.s3.cerbos_policies_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda/"

  depends_on = [module.efs]
}

module "lambda_config_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_cerbos_config_to_efs"
  function_description = "Lambda function to load Cerbos config to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.config_access_point_arn
  s3_bucket_name = module.s3.cerbos_config_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
}

module "lambda_nats_configuration_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_nats_configuration_to_efs"
  function_description = "Lambda function to load NATS configuration to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.nats_config_access_point_arn
  s3_bucket_name = module.s3.nats_config_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
}

module "lambda_telegraf_configuration_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_telegraf_configuration_to_efs"
  function_description = "Lambda function to load Telegraf configuration to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.telegraf_config_access_point_arn
  s3_bucket_name = module.s3.telegraf_config_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
}

#-------------------------------------------------------
# Telegraf Configuration Loader
#-------------------------------------------------------
module "lambda_telegraf_certificates_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_telegraf_certificates_to_efs"
  function_description = "Lambda function to load Telegraf certificates to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.telegraf_certificates_access_point_arn
  s3_bucket_name = module.s3.telegraf_certificates_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
  
}

#-------------------------------------------------------
# RA Physical Configuration Loader
#-------------------------------------------------------
module "lambda_ra_physical_configuration_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_ra_physical_configuration_to_efs"
  function_description = "Lambda function to load RA Physical configuration to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.ra_physical_config_access_point_arn
  s3_bucket_name = module.s3.ra_physical_config_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
  
}

#-------------------------------------------------------
# RA User Configuration Loader
#-------------------------------------------------------
module "lambda_ra_user_configuration_loader" {
  source = "./modules/lambda"
  environment = var.environment
  function_name = "load_ra_user_configuration_to_efs"
  function_description = "Lambda function to load RA User configuration to EFS"
  private_subnets = module.vpc.private_subnet_ids
  efs_file_system_arn = module.efs.file_system_arn
  efs_access_point_arn = module.efs.ra_user_config_access_point_arn
  s3_bucket_name = module.s3.ra_user_config_bucket_name
  security_group_id = module.security_group.lambda_security_group_id
  lambda_zip_path = "${path.module}/modules/lambda"

  depends_on = [module.efs]
  
}


#-------------------------------------------------------
# NAT Gateway
#-------------------------------------------------------
module "nat_gateway" {
  source = "./modules/nat_gateway"

  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_ids[0]
  private_route_table_ids = {
    az1 = module.vpc.private_route_table_ids[0]
    az2 = module.vpc.private_route_table_ids[1]
  }
  environment = var.environment
}

resource "aws_vpc_endpoint" "efs" {
  vpc_id            = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.elasticfilesystem"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [
    module.vpc.private_subnet_ids[0],
    module.vpc.private_subnet_ids[1]
  ]
  security_group_ids = [module.security_group.efs_security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.environment}-efs-vpc-endpoint"
    Environment = var.environment
  }
}

resource "aws_key_pair" "bastion_shared" {
  key_name   = "bastion-shared-${var.environment}"
  public_key = file("~/.ssh/id_ed25519.pub")
}

module "ec2-alpha" {
  source = "./modules/ec2"
  host_name = "bastion-host-${var.environment}-Alpha"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  bastion_security_group_id = module.security_group.bastion_security_group_id
  environment = var.environment
  key_pair_name = aws_key_pair.bastion_shared.key_name

  depends_on = [
    aws_key_pair.bastion_shared,
    module.vpc,
    module.security_group,
    module.nat_gateway
  ]
}

module "ec2-beta" {
  source = "./modules/ec2"
  host_name = "bastion-host-${var.environment}-Beta"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  bastion_security_group_id = module.security_group.bastion_security_group_id
  environment = var.environment
  key_pair_name = aws_key_pair.bastion_shared.key_name

  depends_on = [
    aws_key_pair.bastion_shared,
    module.vpc,
    module.security_group,
    module.nat_gateway
  ]
}

module "roles" {
  source = "./modules/roles"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.ecs_security_group_id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.ecs_security_group_id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_ids = [module.security_group.ecs_security_group_id]
}

# Create InfluxDB instance
#module "influxdb" {
#  source = "./modules/influxdb"

#  environment = var.environment
#  name        = "influxdb-${var.environment}"
#  username    = "influx_user"
#  password    = var.influxdb_admin_password
#  organization = "fortress-power"
#  bucket_name = var.influx_config_bucket_name
#  subnet_ids = module.vpc.public_subnet_ids
#  security_group_ids = [module.security_group.influx_security_group_id]

#  depends_on = [module.nat_gateway]
#}

# Add this directly to your main.tf file, after the security_group module
resource "aws_vpc_endpoint" "timestream_influxdb" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.timestream-influxdb"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.timestream_endpoint.id]
  
  private_dns_enabled = true

  tags = {
    Name        = "${var.environment}-timestream-influxdb-endpoint"
    Environment = var.environment
  }
}

# Add the security group for the VPC endpoint directly in main.tf
resource "aws_security_group" "timestream_endpoint" {
  name        = "${var.environment}-timestream-endpoint-sg"
  description = "Security group for Timestream InfluxDB VPC endpoint"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [module.security_group.ecs_security_group_id]
    description     = "Allow HTTPS from ECS tasks"
  }

  ingress {
    from_port       = 8086
    to_port         = 8086
    protocol        = "tcp"
    security_groups = [module.security_group.ecs_security_group_id]
    description     = "Allow InfluxDB traffic from ECS tasks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-timestream-endpoint-sg"
    Environment = var.environment
  }

  depends_on = [module.security_group]
}