resource "aws_default_vpc" "default-vpc" {

}

resource "aws_default_subnet" "default-subnet-a" {
  availability_zone = "ap-southeast-2a"
  tags = var.elb-tags
}

resource "aws_default_subnet" "default-subnet-b" {
  availability_zone = "ap-southeast-2b"
  tags = var.elb-tags
}

resource "aws_default_subnet" "default-subnet-c" {
  availability_zone = "ap-southeast-2c"
  tags = var.elb-tags

}

resource aws_iam_role "algorims-dev-eks-role" {
  name               = "algorims-eks-master-role"
  assume_role_policy = jsonencode({
    Statement = [
        {
            
            Action    = "sts:AssumeRole"
            Effect    = "Allow"
            Principal = {
              Service = "eks.amazonaws.com"
                }

        }
    ]    
    Version = "2012-10-17"
})

}

resource "aws_iam_role" "algorims-dev-eks-node-role" {
  name = "algorims-eks-node-role"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.algorims-dev-eks-role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.algorims-dev-eks-role.name
}

# Enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.algorims-dev-eks-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       =aws_iam_role.algorims-dev-eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.algorims-dev-eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.algorims-dev-eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AWSCodeCommitReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
  role       = aws_iam_role.algorims-dev-eks-node-role.name
}

resource "aws_eks_cluster" "algorims-dev-eks-cluster" {
  name      = "algorims-eks-cluster"
  role_arn  = aws_iam_role.algorims-dev-eks-role.arn
  version   = "1.29"
  vpc_config {
    subnet_ids              = [aws_default_subnet.default-subnet-a.id,aws_default_subnet.default-subnet-b.id,aws_default_subnet.default-subnet-c.id]
    security_group_ids      = [aws_security_group.algorims-dev-sg-master.id]
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api","audit", "authenticator", "controllerManager", "scheduler"]

  tags                      = var.tags
}

resource "aws_security_group" "algorims-dev-sg-master" {
  name        = "algorims-dev-master"
  tags        = var.tags
  description = "eks cluster sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "algorims-dev-sg-nodes" {
  name        = "algorims-sg-nodes"
  description = "sg for nodes"
  vpc_id      = aws_default_vpc.default-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.algorims-dev-sg-master.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "cluster_inbound" {
  from_port                = 0
  protocol                 = "-1"
  #security_group_id        = module.aws-eks-cluster.aws-eks-sg-id
  security_group_id        = aws_security_group.algorims-dev-sg-master.id
  source_security_group_id = aws_security_group.algorims-dev-sg-nodes.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_eks_node_group" "algorims-dev-node-group" {
  cluster_name    = aws_eks_cluster.algorims-dev-eks-cluster.name
  node_role_arn   = aws_iam_role.algorims-dev-eks-node-role.arn
  subnet_ids      = [aws_default_subnet.default-subnet-a.id,aws_default_subnet.default-subnet-b.id,aws_default_subnet.default-subnet-c.id]
  instance_types  = ["t3.medium"] # if requirement for backend is 4cpu for HA 3 replicas change to t3 large
  version         = "1.29"


scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
}



resource "aws_iam_openid_connect_provider" "openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates[0].sha1_fingerprint]
  url              = aws_eks_cluster.algorims-dev-eks-cluster.identity[0].oidc[0].issuer
  depends_on      = [aws_eks_cluster.algorims-dev-eks-cluster]
}
