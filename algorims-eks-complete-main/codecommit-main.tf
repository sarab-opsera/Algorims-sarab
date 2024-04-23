

module "aws-code-commit-ci-repo" {
  source            = "/Users/prasai/gitclones/algorims-eks-complete-main/algorims-module-aws-code-commit"
  
  repository_name   = var.aws-code-commit-ci-repository-name
  description       = var.aws-code-commit-ci-description
  triggers          = [
    {
    name  = "all"
    events  = ["all"]
    destination_arn = aws_lambda_function.algorims-lamda-codecommit.arn
    },
  ]
  
  tags              = var.tags

}


module "aws-code-commit-cd-repo" {
  source            = "/Users/prasai/gitclones/algorims-eks-complete-main/algorims-module-aws-code-commit"
  
  repository_name   = var.aws-code-commit-cd-repository-name
  description       = var.aws-code-commit-cd-description
  tags              = var.tags

}

resource "aws_iam_role" "algorims-ci-lambdarole" {
  name = "algorims-ci-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "algorims-ci-lambda-policy" {
  name = "algorims-ci-lambda-policy"
  role = aws_iam_role.algorims-ci-lambdarole.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codebuild:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

}

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/code/lambda_function.py" 
  output_path = "trigger.zip"
}

resource "aws_lambda_function" "algorims-lamda-codecommit" {
        function_name = "lambda-ci-codebuild-function"
        filename      = "trigger.zip"
        source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
        role          = aws_iam_role.algorims-ci-lambdarole.arn
        runtime       = "python3.9"
        handler       = "lambda_function.lambda_handler"
        timeout       = 10
        
}

resource "aws_lambda_permission" "algorims-lamda-codecommit-permission" {

  function_name =  aws_lambda_function.algorims-lamda-codecommit.function_name
  statement_id = "1"
  action = "lambda:InvokeFunction"
  principal = "codecommit.amazonaws.com"
  source_arn = module.aws-code-commit-ci-repo.arn
  
}

