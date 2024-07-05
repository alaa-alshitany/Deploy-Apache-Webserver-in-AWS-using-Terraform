resource "aws_autoscaling_group" "web-scaling" {
  name                      = "webserver-sg"
  max_size                  = 1
  min_size                  = 1
  vpc_zone_identifier = aws_subnet.private_subnets[*].id

  launch_template {
    id = aws_launch_template.launch_temp.id
  }
}