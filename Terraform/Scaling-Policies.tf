resource "aws_autoscaling_policy" "scaling-in" {
  name                   = "ScaleInPolicy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-scaling.name
}

resource "aws_autoscaling_policy" "scaling-out" {
  name                   = "ScaleOutPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web-scaling.name
}