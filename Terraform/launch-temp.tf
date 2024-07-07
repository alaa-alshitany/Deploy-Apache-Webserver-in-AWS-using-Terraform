resource "aws_iam_instance_profile" "instance_profile" {
  name = "web_server_profile"
  role = aws_iam_role.Terraform_Role.name
}

resource "aws_launch_template" "launch_temp" {
  name          = "web_config"
  image_id      = aws_ami_from_instance.golden_ami.id
  instance_type = "t2.micro"
  key_name = "key"
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
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}