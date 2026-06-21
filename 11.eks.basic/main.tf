terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  cluster_name         = var.cluster_name
  vpc_cidr_block       = var.vpc_cidr_block
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  public_subnet_ids  = module.vpc.public_subnet_ids

  depends_on = [module.vpc]
}

module "eks_nodegroup" {
  source = "./modules/eks-nodegroup"

  cluster_name        = var.cluster_name
  nodegroup_name      = var.nodegroup_name
  node_instance_type  = var.node_instance_type
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_volume_size    = var.node_volume_size
  ssh_public_key_name = var.ssh_public_key_name
  subnet_ids          = module.vpc.public_subnet_ids

  depends_on = [module.eks_cluster]
}

module "eks_ebs_csi" {
  source = "./modules/eks-ebs-csi"

  cluster_name      = var.cluster_name
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn
  oidc_provider_url = module.eks_cluster.oidc_provider_url

  depends_on = [module.eks_nodegroup]
}
