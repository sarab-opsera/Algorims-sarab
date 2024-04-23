resource "helm_release" "aws-certmanager" {
  namespace        = "kube-system"
  create_namespace = false
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"



  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.algorims-certmgr-eks-role-name
  }

set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.algorims-certmgr-eks-dev-role.arn
  }

   set {
    name  = "installCRDs"
    value = "true"
  }



depends_on = [ aws_eks_cluster.algorims-dev-eks-cluster,aws_eks_node_group.algorims-dev-node-group, helm_release.aws-load-balancer-controller, helm_release.nginx-ingress-controller, aws_iam_role.algorims-certmgr-eks-dev-role ]
}


resource "aws_iam_role" "algorims-certmgr-eks-dev-role" {

  name = var.algorims-certmgr-eks-role-name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": aws_iam_openid_connect_provider.openid.arn
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${replace(aws_iam_openid_connect_provider.openid.url, "https://", "")}:sub": "sts.amazonaws.com",
            "${replace(aws_iam_openid_connect_provider.openid.url, "https://", "")}:sub": "system:serviceaccount:kube-system:${var.algorims-certmgr-eks-role-name}"
          }
        }
      }
    ]
  })
  tags = var.tags

}

resource "aws_iam_role_policy" "algorims-certmgr-eks-dev-policy" {
    
    name = "algorims-certmanager-eks-policy"
    role = aws_iam_role.algorims-certmgr-eks-dev-role.id
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/${data.aws_route53_zone.algorims-zone-id.id}"
      },
    ]
  })
  
}


            

resource "kubectl_manifest" "cluster-issuer" {
  yaml_body = <<YAML

apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: prasad@algorims.com
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
      - http01:
          ingress:
            class: nginx
        
YAML

  depends_on = [helm_release.aws-certmanager]
}          


