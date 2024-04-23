data "aws_caller_identity" "current" {}

data "tls_certificate" "cert" {
  url               = aws_eks_cluster.algorims-dev-eks-cluster.identity[0].oidc[0].issuer

}

data "kubernetes_service" "ingress-nginx" {
  metadata {
    namespace = "ingress-nginx"
    name = "nginx-ingress-controller"
  }

  depends_on = [helm_release.nginx-ingress-controller]

}


data "aws_lb" "ingress-nginx" {
  name = var.ingress-svc-name
  # "k8s-ingressn-nginxing-69f9023ccb"
}


data "aws_route53_zone" "algorims-zone-id" {
  name = var.domain-name
  private_zone = false

}