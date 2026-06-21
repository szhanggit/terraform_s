output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.eks_cluster.cluster_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks_cluster.oidc_provider_url
}

output "nodegroup_arn" {
  value = module.eks_nodegroup.nodegroup_arn
}

output "nodegroup_status" {
  value = module.eks_nodegroup.nodegroup_status
}

output "node_role_arn" {
  value = module.eks_nodegroup.node_role_arn
}

output "ebs_csi_driver_role_arn" {
  value = module.eks_ebs_csi.ebs_csi_driver_role_arn
}
