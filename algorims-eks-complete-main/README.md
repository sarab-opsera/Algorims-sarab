# Setup CI/CD with EKS

## How to Deploy

1. Git clone this repo, execute below commands
    a. tf init
    b. tf plan -out tf.plan  <- key in your password for docker registry
    c. tf apply tf.plan

2. Once successfully applied you will get the output for the CI and CD repo, as below
  - git-repo-name          = "algorims-dev-ci" -> null
  - git-repo-name-eks      = "algorims-dev-cd" -> null
  - git-repo-url-arn       = "arn:aws:codecommit:ap-southeast-2:561580620525:algorims-dev-ci" -> null
  - git-repo-url-arn-eks   = "arn:aws:codecommit:ap-southeast-2:561580620525:algorims-dev-cd" -> null
  - git-repo-url-https     = "https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-ci" -> null
  - git-repo-url-https-eks = "https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-cd" -> null
  - git-repo-url-ssh       = "ssh://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-ci" -> null
  - git-repo-url-ssh-eks   = "ssh://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-cd" -> null     

3. Follow the document (https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-gc.html) to create the crednetials for codecommit

4. Clone the CI and CD repository to you local, make note of the git credentials created in the previous step

5. Once you have clone repo move the algorims-dev-ci-repo.zip and algorims-dev-cd-repo.zip repo and commit and push to the corresponding CI and CD Repository 

6. After committ and push the CI will trigger codebuild and code build will create new image in ECR
    codecommit -> Lambda Trigger -> codebuild -> ECR

7. From you CLI run the below command to get the kubeconfig file for the cluster just created

    aws eks update-kubeconfig --region ap-southeast-2 --name algorims-eks-cluster

8. Get the ingress endpoint for argocd

    k get ing -A

9. Log in to the above endpoint "https://argocd.app.algorims.net/" using admin and password you can get from this command (kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)


10. Once you are in argocd go to setting and setup the cd repository using https (https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-cd) provide the credentials noted from point 3

11. Create a new application with the above CD repo

12. Once its depoyed use the endpoint (https://hello-world.app.algorims.net/hello) which is ingress endppoint for the application



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.21.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.21.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.2.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-code-commit-cd-repo"></a> [aws-code-commit-cd-repo](#module\_aws-code-commit-cd-repo) | git::git@github.com:thangap-cloud/algorims-module-aws-code-commit.git | n/a |
| <a name="module_aws-code-commit-ci-repo"></a> [aws-code-commit-ci-repo](#module\_aws-code-commit-ci-repo) | git::git@github.com:thangap-cloud/algorims-module-aws-code-commit.git | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.algorims-ci-codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_default_subnet.default-subnet-a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws_default_subnet.default-subnet-b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws_default_subnet.default-subnet-c](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws_default_vpc.default-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_ecr_repository.algorims-ci-container-repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_eks_cluster.algorims-dev-eks-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.algorims-dev-node-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.openid](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.algorims-certmgr-eks-dev-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.algorims-ci-codebuild-iam-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.algorims-ci-lambdarole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.algorims-dev-eks-node-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.algorims-dev-eks-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.algorims-elb-eks-dev-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.algorims-certmgr-eks-dev-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.algorims-ci-codebuild-iam-rolepolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.algorims-ci-lambda-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.algorims-elb-eks-dev-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AWSCodeCommitReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.algorims-lamda-codecommit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.algorims-lamda-codecommit-permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.algorims-ci-s3-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.algorims-dev-sg-master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.algorims-dev-sg-nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.algorims-ci-ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws-certmanager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.aws-load-balancer-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx-ingress-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.cluster-issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [archive_file.python_lambda_package](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_lb.ingress-nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.algorims-zone-id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [kubernetes_service.ingress-nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [tls_certificate.cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_algorims-aws-eks-lb-controller-role-name"></a> [algorims-aws-eks-lb-controller-role-name](#input\_algorims-aws-eks-lb-controller-role-name) | n/a | `string` | `"algorims-aws-eks-lb-controller-role"` | no |
| <a name="input_algorims-certmgr-eks-role-name"></a> [algorims-certmgr-eks-role-name](#input\_algorims-certmgr-eks-role-name) | n/a | `string` | `"algorims-certmgr-eks-role"` | no |
| <a name="input_algorims-dev-cirepo"></a> [algorims-dev-cirepo](#input\_algorims-dev-cirepo) | n/a | `string` | `"https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-ci"` | no |
| <a name="input_aws-code-commit-cd-description"></a> [aws-code-commit-cd-description](#input\_aws-code-commit-cd-description) | The description of the repository. This needs to be less than 1000 characters | `string` | `null` | no |
| <a name="input_aws-code-commit-cd-repository-name"></a> [aws-code-commit-cd-repository-name](#input\_aws-code-commit-cd-repository-name) | The name for the repository. This needs to be less than 100 characters. | `string` | `"algorims-dev-cd"` | no |
| <a name="input_aws-code-commit-ci-description"></a> [aws-code-commit-ci-description](#input\_aws-code-commit-ci-description) | The description of the repository. This needs to be less than 1000 characters | `string` | `null` | no |
| <a name="input_aws-code-commit-ci-repository-name"></a> [aws-code-commit-ci-repository-name](#input\_aws-code-commit-ci-repository-name) | The name for the repository. This needs to be less than 100 characters. | `string` | `"algorims-dev-ci"` | no |
| <a name="input_aws-dynamodb-table-hash-key"></a> [aws-dynamodb-table-hash-key](#input\_aws-dynamodb-table-hash-key) | backend dynamo db table haskey | `string` | `"LockID"` | no |
| <a name="input_aws-dynamodb-table-name"></a> [aws-dynamodb-table-name](#input\_aws-dynamodb-table-name) | backend dynamo db table name. | `string` | `null` | no |
| <a name="input_aws-s3-bucket-backend-name"></a> [aws-s3-bucket-backend-name](#input\_aws-s3-bucket-backend-name) | backend s3 bucket name. | `string` | `null` | no |
| <a name="input_domain-name"></a> [domain-name](#input\_domain-name) | n/a | `string` | `"algorims.net"` | no |
| <a name="input_ecr-container-repo-password"></a> [ecr-container-repo-password](#input\_ecr-container-repo-password) | provide Elastic Container Registry Password | `string` | n/a | yes |
| <a name="input_elb-tags"></a> [elb-tags](#input\_elb-tags) | n/a | `map(any)` | <pre>{<br>  "kubernetes.io/cluster/algorims-eks-cluster": "owned",<br>  "kubernetes.io/role/elb": "1"<br>}</pre> | no |
| <a name="input_ingress-svc-name"></a> [ingress-svc-name](#input\_ingress-svc-name) | n/a | `string` | `"k8s-ingressn-nginxing-69f9023ccb"` | no |
| <a name="input_record-name"></a> [record-name](#input\_record-name) | n/a | `string` | `"*.app.algorims.net"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | <pre>{<br>  "env": "dev",<br>  "ownedBy": "algorims",<br>  "terraform": true<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_git-repo-name"></a> [git-repo-name](#output\_git-repo-name) | git repo name |
| <a name="output_git-repo-name-eks"></a> [git-repo-name-eks](#output\_git-repo-name-eks) | git repo name |
| <a name="output_git-repo-url-arn"></a> [git-repo-url-arn](#output\_git-repo-url-arn) | git repo arn |
| <a name="output_git-repo-url-arn-eks"></a> [git-repo-url-arn-eks](#output\_git-repo-url-arn-eks) | git repo arn |
| <a name="output_git-repo-url-https"></a> [git-repo-url-https](#output\_git-repo-url-https) | git repo clone URL https |
| <a name="output_git-repo-url-https-eks"></a> [git-repo-url-https-eks](#output\_git-repo-url-https-eks) | git repo clone URL https |
| <a name="output_git-repo-url-ssh"></a> [git-repo-url-ssh](#output\_git-repo-url-ssh) | git repo clone URL ssh |
| <a name="output_git-repo-url-ssh-eks"></a> [git-repo-url-ssh-eks](#output\_git-repo-url-ssh-eks) | git repo clone URL ssh |
| <a name="output_k8s-service-name"></a> [k8s-service-name](#output\_k8s-service-name) | n/a |
