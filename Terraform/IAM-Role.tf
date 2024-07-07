resource "aws_iam_role" "Terraform_Role" {
  name = "s3_and_session_manager_role"
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
  role       = aws_iam_role.Terraform_Role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# session manager policy 
resource "aws_iam_policy" "session_manager_policy" {
  name        = "Session_Manager_Policy"
  description = "Policy for Session Manager Access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "ssm:StartSession"
        ],
        Resource  = "*"
      }
    ]
  })
}

# attach session manager policy to IAM role
resource "aws_iam_role_policy_attachment" "session_manager_policy_attachment" {
  role       = aws_iam_role.Terraform_Role.name
  policy_arn = aws_iam_policy.session_manager_policy.arn
}