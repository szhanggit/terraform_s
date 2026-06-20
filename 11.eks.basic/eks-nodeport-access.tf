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
