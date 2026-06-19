# Equivalent of:
# eksctl create nodegroup --cluster=eksdemo1 --region=ca-central-1 --name=eksdemo1-ng-public1
#   --node-type=t3.small --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20
#   --ssh-access --ssh-public-key=kube-demo --managed
#   --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access
resource "aws_eks_node_group" "public1" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = [for s in aws_subnet.public : s.id]

  instance_types = [var.node_instance_type]
  disk_size      = var.node_volume_size

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  remote_access {
    ec2_ssh_key = var.ssh_public_key_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_pull_only,
    aws_iam_role_policy_attachment.ssm_managed_instance_core,
  ]
}
