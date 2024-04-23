"""
A simple AWS Lambda function to trigger CodeBuild project 
on push events to CodeCommit repository
"""
import boto3
def lambda_handler(event, context):

    client = boto3.client(service_name='codebuild', region_name='ap-southeast-2')
    new_build = client.start_build(projectName='algorims-ci-codebuild-project')