# IAM role assumed by the EKS control plane
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS control plane only - no managed node group (--without-nodegroup)
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.public_subnet_ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# Grants the CodePipeline deploy stage's assumed role cluster-admin access via
# EKS access entries (replaces manually editing the aws-auth ConfigMap).
resource "aws_eks_access_entry" "codebuild_kubectl" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.codebuild_kubectl_role_arn
}

resource "aws_eks_access_policy_association" "codebuild_kubectl_admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_eks_access_entry.codebuild_kubectl.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

# Equivalent of:
# eksctl utils associate-iam-oidc-provider --region ca-central-1 --cluster eksdemo1 --approve
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

  tags = {
    Name = "${var.cluster_name}-oidc"
  }
}

# Allow inbound NodePort traffic (30000-32767) from the internet so that
# NodePort services (e.g. usermgmt-restapp-service on 31231) are reachable
# from outside the VPC. The EKS-managed cluster security group only allows
# traffic from itself by default.
resource "aws_security_group_rule" "nodeport_ingress" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  description       = "NodePort range for externally accessible NodePort services"
}
