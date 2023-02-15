resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group.name
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = [ var.subnets[0], var.subnets[1] ]
  instance_types = var.node_group.instance_types

  scaling_config {
    desired_size = var.node_group.desired_size
    max_size     = var.node_group.max_size
    min_size     = var.node_group.min_size
  }

  update_config {
    max_unavailable = var.node_group.max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_role-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "node_group_role" {
  name = "${var.node_group.name}-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_group_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role.name
}