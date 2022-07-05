terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
}
    
provider "aws" {
  region = "${secrets.AWS_REGION}"
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


resource "aws_dynamodb_table" "tf_mentions_table" {
 name = "tf-mentions-table"
 billing_mode = "PROVISIONED"
 read_capacity= "5"
 write_capacity= "5"
 attribute {
  name = "postId"
  type = "S"
 }
 hash_key = "postId"

 point_in_time_recovery { enabled = true } 
 server_side_encryption { enabled = false } 
 lifecycle {ignore_changes = [write_capacity, read_capacity]}
}
          
resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
   name = "dynamodb_lambda_policy"
   role = aws_iam_role.iam_for_lambda.id
   policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
           "Effect" : "Allow",
           "Action" : ["dynamodb:*"],
           "Resource" : "${aws_dynamodb_table.tf_mentions_table.arn}"
        }
      ]
   })
}
