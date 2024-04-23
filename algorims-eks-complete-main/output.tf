output "git-repo-name" {
    description = "git repo name"
    value       = module.aws-code-commit-ci-repo.name
  
}

output "git-repo-url-ssh" {
    description = "git repo clone URL ssh"
    value       = module.aws-code-commit-ci-repo.clone_url_ssh
}

output "git-repo-url-https" {
    description = "git repo clone URL https"
    value       = module.aws-code-commit-ci-repo.clone_url_http
}

output "git-repo-url-arn" {
    description = "git repo arn"
    value       = module.aws-code-commit-ci-repo.arn
  
}

output "git-repo-name-eks" {
    description = "git repo name"
    value       = module.aws-code-commit-cd-repo.name
  
}

output "git-repo-url-ssh-eks" {
    description = "git repo clone URL ssh"
    value       = module.aws-code-commit-cd-repo.clone_url_ssh
}

output "git-repo-url-https-eks" {
    description = "git repo clone URL https"
    value       = module.aws-code-commit-cd-repo.clone_url_http
}

output "git-repo-url-arn-eks" {
    description = "git repo arn"
    value       = module.aws-code-commit-cd-repo.arn
  
}

output "k8s-service-name" {

    value = data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
  
}