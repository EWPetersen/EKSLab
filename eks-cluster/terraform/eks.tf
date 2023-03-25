# eks.tf

resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.private.*.id
  }

  depends_on = [
    aws_security_group.eks_cluster,
  ]
}

resource "aws_eks_fargate_profile" "this" {
  cluster_name = aws_eks_cluster.this.name
  fargate_profile_name = "fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks_fargate.arn

  selector {
    namespace = "default"
  }

  depends_on = [
    aws_security_group.eks_cluster,
  ]
}
