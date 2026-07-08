# Container Insights via the amazon-cloudwatch-observability EKS add-on,
# using EKS Pod Identity (AWS's current recommended method - see
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Observability-EKS-addon.html).
#
# Superseded the tutorial's manual cloudwatch-agent/fluentd DaemonSets: that
# image's AWS SDK build didn't pick up IRSA's AWS_WEB_IDENTITY_TOKEN_FILE
# credentials for its metrics exporter even with AWS_SDK_LOAD_CONFIG set, so
# no ContainerInsights metrics or /performance logs ever reached CloudWatch.
# Pod Identity uses a different credential-delivery mechanism (an in-cluster
# credential endpoint via the eks-pod-identity-agent daemonset) that this
# AWS-maintained add-on supports correctly out of the box.

data "aws_iam_policy_document" "cloudwatch_agent_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudwatch_agent" {
  name               = "${var.cluster_name}-cloudwatch-agent-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_agent_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.cloudwatch_agent.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Prerequisite: runs on every node, serves pod-identity credential requests.
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = var.cluster_name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = var.cluster_name
  addon_name   = "amazon-cloudwatch-observability"

  pod_identity_association {
    role_arn        = aws_iam_role.cloudwatch_agent.arn
    service_account = "cloudwatch-agent"
  }

  depends_on = [aws_eks_addon.pod_identity_agent]
}
