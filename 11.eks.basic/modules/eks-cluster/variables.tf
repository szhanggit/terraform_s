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

variable "codebuild_kubectl_role_arn" {
  description = "IAM role ARN assumed by the CodePipeline deploy stage; granted cluster-admin via an EKS access entry"
  type        = string
}
