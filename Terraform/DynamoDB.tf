resource "aws_dynamodb_table" "dynamo_tb" {
  name           = var.dynamo_tb_name
  read_capacity  = 10
  write_capacity = 10
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}