terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
}
    
provider "aws" {}

terraform {
  backend "s3" {
    bucket         = "tf-state-merkakis"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-state-merkakis-db"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
 name = "iam_for_lambda"

 assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     }
   ]
  })
}
          
resource "aws_iam_role_policy_attachment" "lambda_policy" {
   role = aws_iam_role.iam_for_lambda.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

