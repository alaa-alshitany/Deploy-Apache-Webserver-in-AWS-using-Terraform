resource "aws_autoscaling_group" "web-scaling" {
  name                      = "webserver-sg"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = module.network_module.private_subnets

  launch_template {
    id = aws_launch_template.launch_temp.id
  }
  target_group_arns = [aws_lb_target_group.target-group.arn]
}