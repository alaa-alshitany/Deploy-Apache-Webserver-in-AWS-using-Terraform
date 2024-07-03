resource "aws_s3_bucket" "bk" {
  bucket = var.bucket_names[0]
  tags = {
    Name        = var.bucket_names[0]
  }
}