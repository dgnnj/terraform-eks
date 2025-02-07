resource "aws_eks_addon" "eks_addon_vpc" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}