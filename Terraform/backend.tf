terraform {
  backend "s3" {
    bucket         	   = "statefile-bk"
    key                = "terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
    dynamodb_table = "lock_tb"
  }
}
