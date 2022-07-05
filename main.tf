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

terraform {
  backend "s3" {
    bucket         = "tf-state-merkakis"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-state-merkakis-db"
  }
}
