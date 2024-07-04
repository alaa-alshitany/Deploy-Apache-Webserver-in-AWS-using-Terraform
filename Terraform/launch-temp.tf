resource "aws_iam_instance_profile" "instance_profile" {
  name = "web_server_profile"
  role = aws_iam_role.s3_and_session_manager_role.name
}

resource "aws_launch_template" "launch_temp" {
  name          = "web_config"
  image_id      = "ami-07f406bc85a990c00"
  instance_type = "t2.micro"
  user_data = base64encode(<<-EOF
              #!/bin/bash
              aws s3 cp s3://web-conf-bk/user-data.sh /home/ec2-user/user-data.sh
              chmod +x /home/ec2-user/user-data.sh
              /home/ec2-user/user-data.sh
              EOF
  )
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name 
  } 
}