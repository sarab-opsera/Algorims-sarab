resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.9.7"
  create_namespace = true

depends_on = [ aws_eks_cluster.algorims-dev-eks-cluster, aws_eks_node_group.algorims-dev-node-group, helm_release.aws-load-balancer-controller, helm_release.aws-certmanager, helm_release.nginx-ingress-controller ]

}


resource "kubectl_manifest" "argocd-ingress" {
  yaml_body = <<YAML

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-production
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  rules:
  - host: argocd.app.algorims.net 
    http:
      paths:
      - backend:
          service:
            name: argocd-server
            port:
              name: https
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - argocd.app.algorims.net
    secretName: letsencrypt-production

  YAML     
depends_on = [ helm_release.argocd ]
} 
