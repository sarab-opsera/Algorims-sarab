variable "ecr-container-repo-password" {
  type        = string
  description = "provide Elastic Container Registry Password"
}

variable "elb-tags" {
  default = {"kubernetes.io/role/elb"="1","kubernetes.io/cluster/algorims-eks-cluster"="owned" }
  type = map(any)
}
variable "algorims-certmgr-eks-role-name" {
  default = "algorims-certmgr-eks-role"
  
}
variable "algorims-dev-cirepo" {
  default = "https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-ci"

}

variable "algorims-dev-cdrepo" {
  default = "https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/algorims-dev-cd"

}

variable "algorims-aws-eks-lb-controller-role-name" {
default = "algorims-aws-eks-lb-controller-role"
  
}

variable "ingress-svc-name" {
  default = "k8s-ingressn-nginxing-69f9023ccb"
}

variable "domain-name" {
  default = "algorims.net"
}

variable "record-name" {
  default = "*.app.algorims.net"
  
}

variable "aws-code-commit-ci-repository-name" {
  description   = "The name for the repository. This needs to be less than 100 characters."
  type          = string
  default       = "algorims-dev-ci"
}

variable "aws-code-commit-ci-description" {
  description = "The description of the repository. This needs to be less than 1000 characters"
  type        = string
  default     = null    
}

variable "aws-code-commit-cd-repository-name" {
  description   = "The name for the repository. This needs to be less than 100 characters."
  type          = string
  default       = "algorims-dev-cd"
}

variable "aws-code-commit-cd-description" {
  description = "The description of the repository. This needs to be less than 1000 characters"
  type        = string
  default     = null    
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {
    ownedBy   = "algorims"
    env       = "dev"
    terraform = true
  } 
}

variable "aws-s3-bucket-backend-name" {
  description = "backend s3 bucket name."
  type        = string
  default     = null
}

variable "aws-dynamodb-table-name" {
  description = "backend dynamo db table name."
  type        = string
  default     = null 
}

variable "aws-dynamodb-table-hash-key" {
  description = "backend dynamo db table haskey"
  type        = string
  default     = "LockID"
  
}