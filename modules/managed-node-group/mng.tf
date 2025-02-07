resource "aws_launch_template" "eks_launch_template" {
  name_prefix = "${var.project_name}-launch-template"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  instance_type = "t3.small"

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-node"
      }
    )
  }
}

resource "aws_eks_node_group" "eks_managed_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_name}-nodegroup"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    var.subnet_private_1a,
    var.subnet_private_1b
  ]

  capacity_type = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryPullOnly,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-nodegroup"
    }
  )
}