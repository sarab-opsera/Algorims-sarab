resource "aws_s3_bucket" "algorims-ci-s3-bucket" {
  bucket_prefix = "algorims-codebuild-hello-world"
  force_destroy = true
}

resource "aws_ecr_repository" "algorims-ci-container-repo" {
  name                 = "algorims-container-repo" # donot change this name as its provided in ci repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

resource "aws_ssm_parameter" "algorims-ci-ssm" {
  name        = "/codeBuild/dockerPassword"
  description = "The Dockerhub password"
  type        = "SecureString"
  #value       = var.ecr-container-repo-password
  value        = "Srisairam@1234"
}

resource "aws_iam_role" "algorims-ci-codebuild-iam-role" {
  name = "algorims-ci-codebuild-iamrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "algorims-ci-codebuild-iam-rolepolicy" {
  role = aws_iam_role.algorims-ci-codebuild-iam-role.name
  name = "algorims-ci-codebuild-iam-role-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.algorims-ci-s3-bucket.arn}",
        "${aws_s3_bucket.algorims-ci-s3-bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "codecommit:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action" : [
        "ssm:GetParameters"
      ],
      "Resource" : "*",
      "Effect" : "Allow"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "algorims-ci-codebuild" {
  name          = "algorims-ci-codebuild-project" # if you change the name change it code/lambda_function.py as well
  description   = "dev java app build project"
  build_timeout = "5"
  service_role  = aws_iam_role.algorims-ci-codebuild-iam-role.arn
  
  artifacts {
    type     = "S3"
    location = aws_s3_bucket.algorims-ci-s3-bucket.bucket
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.algorims-ci-s3-bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.algorims-ci-s3-bucket.id}/build-log"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = var.algorims-dev-cirepo
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "main"

depends_on = [ module.aws-code-commit-ci-repo, module.aws-code-commit-cd-repo, aws_ecr_repository.algorims-ci-container-repo ]
}