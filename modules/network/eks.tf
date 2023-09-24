module "sg-name" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "eks-sg"
}

module "eks-cluster-name" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "eks-cluster"
}

module "eks-role-name" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "controlplane"
}

module "worker-role-name" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "worker-permission"
}

module "node-group-name1" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "regular-workload"
}

module "node-group-name2" {
  source    = "../label"
  namespace = var.project
  stage     = var.environment
  name      = "web-workload"
}
resource "aws_iam_role" "eks-role" {
  name = module.eks-role-name.id
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
}


resource "aws_iam_role" "workder-role" {
  name = module.worker-role-name.id
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  ]
}

resource "aws_security_group" "eks-sg" {
  name        = module.sg-name.id
  description = "eks master security group"
  vpc_id      = aws_vpc.vpc-local.id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_cluster" "main-cluster" {
  name       = module.eks-cluster-name.id
  role_arn   = aws_iam_role.eks-role.arn
  depends_on = [aws_iam_role.eks-role]
  tags = {
    Name = "${var.environment}-eks-cluster"
  }
  vpc_config {
    subnet_ids = data.aws_subnets.public.ids
  }
  enabled_cluster_log_types = ["api"]
  version                   = "1.27"
}

resource "aws_cloudwatch_log_group" "eks-loggroup" {
  name              = "/aws/eks/${module.eks-cluster-name.id}/cluster"
  retention_in_days = 1
}

resource "aws_eks_node_group" "main-ng" {
  node_group_name = module.node-group-name1.id
  depends_on      = [aws_iam_role.workder-role, aws_eks_cluster.main-cluster]
  cluster_name    = aws_eks_cluster.main-cluster.name
  node_role_arn   = aws_iam_role.workder-role.arn
  subnet_ids      = data.aws_subnets.private.ids
  release_version = "1.27.1-20230607"
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]
  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_node_group" "main-ng1" {
  node_group_name = module.node-group-name2.id
  depends_on      = [aws_iam_role.workder-role, aws_eks_cluster.main-cluster]
  cluster_name    = aws_eks_cluster.main-cluster.name
  node_role_arn   = aws_iam_role.workder-role.arn
  subnet_ids      = data.aws_subnets.private.ids
  release_version = "1.27.1-20230607"
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.small"]
  update_config {
    max_unavailable = 1
  }
}