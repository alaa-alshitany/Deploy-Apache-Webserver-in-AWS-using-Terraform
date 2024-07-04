resource "aws_s3_bucket" "bk" {
  bucket = var.bucket_names[0]
  tags = {
    Name        = var.bucket_names[0]
  }
}

resource "aws_s3_bucket" "bk_web" {
  bucket = var.bucket_names[1]
  tags = {
    Name        = var.bucket_names[1]
  }
}