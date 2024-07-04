resource "aws_iam_role" "s3-role" {
  name = "s3-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

#policy for s3 to allow put & get objects 
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-access-policy"
  description = "Policy to allow PUT/GET access to the S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.bk_web.arn}/*"
      }
    ]
  })
}

# attach S3 policy to IAM role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.s3-role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}