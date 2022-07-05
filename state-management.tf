resource "aws_s3_bucket" "bucket" {
  bucket = "${secrets.AWS_TF_STATE_BUCKET}"
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "${secrets.AWS_TF_DYNAMO_DB_TABLE}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "terraform-lock"
  }
}

terraform {
  backend "s3" {
    bucket         = "${secrets.AWS_TF_STATE_BUCKET}"
    key            = "terraform.tfstate"
    region         = "${secrets.AWS_REGION}"
    dynamodb_table = "${secrets.AWS_TF_DYNAMO_DB_TABLE}"
  }
}