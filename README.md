# Deploy Apache Web Server using Terraform IaC

## 📝 Overview
This project aims to deploy Apache Webserver in AWS cloud using Terraform as IaC.


![webserver](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/assets/71197108/711eb419-8a9e-44b4-bf7b-2fdbcd2bfcab)

---

## 📋 Prerequisites
1- Create below resources using  Terraform IaC
    
    - Create S3 Bucket to store the terraform statefiles
    ```
    resource "aws_s3_bucket" "bk" {
  bucket = "YOUR BUCKET NAME"
  tags = {
    Name        = "YOUR BUCKET NAME"
  }
}
    ```

    - Create DynamoDB
    ```
    resource "aws_dynamodb_table" "dynamo_tb" {
  name           = "YOUR TABLE NAME"
  read_capacity  = 10
  write_capacity = 10
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
    ```