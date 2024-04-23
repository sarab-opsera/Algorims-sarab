resource "helm_release" "nginx-ingress-controller" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace         = "ingress-nginx"
  create_namespace  = true


  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

 values = [
    <<EOF
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-name: ingresscontrolersvc
    service.beta.kubernetes.io/aws-load-balancer-type: external
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
EOF
  ]
  
  depends_on = [ aws_eks_cluster.algorims-dev-eks-cluster,aws_eks_node_group.algorims-dev-node-group, helm_release.aws-load-balancer-controller ]

}


resource "aws_route53_record" "elb" {
    
  allow_overwrite = true
  zone_id = data.aws_route53_zone.algorims-zone-id.id
  name    = var.record-name
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = data.aws_lb.ingress-nginx.zone_id
    evaluate_target_health = false
  }
  depends_on = [ helm_release.nginx-ingress-controller ]
}

