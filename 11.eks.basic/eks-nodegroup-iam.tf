# IAM role assumed by the EKS managed node group's EC2 instances
resource "aws_iam_role" "nodegroup" {
  name = "${var.cluster_name}-${var.nodegroup_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Baseline managed policies required by every EKS managed node group
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_pull_only" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --full-ecr-access
resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  role       = aws_iam_role.nodegroup.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# --asg-access
resource "aws_iam_role_policy" "asg_access" {
  name   = "PolicyAutoScaling"
  role   = aws_iam_role.nodegroup.name
  policy = local.asg_access_policy
}

# --external-dns-access
resource "aws_iam_role_policy" "external_dns_changeset" {
  name   = "PolicyExternalDNSChangeSet"
  role   = aws_iam_role.nodegroup.name
  policy = local.external_dns_changeset_policy
}

resource "aws_iam_role_policy" "external_dns_hostedzones" {
  name   = "PolicyExternalDNSHostedZones"
  role   = aws_iam_role.nodegroup.name
  policy = local.external_dns_hostedzones_policy
}

# --appmesh-access
resource "aws_iam_role_policy" "appmesh_access" {
  name   = "PolicyAppMesh"
  role   = aws_iam_role.nodegroup.name
  policy = local.appmesh_access_policy
}

# --alb-ingress-access
resource "aws_iam_role_policy" "alb_ingress_access" {
  name   = "PolicyAWSLoadBalancerController"
  role   = aws_iam_role.nodegroup.name
  policy = local.alb_ingress_access_policy
}
