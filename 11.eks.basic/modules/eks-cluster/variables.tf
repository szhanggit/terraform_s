variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the EKS control plane's VPC config"
  type        = list(string)
}
