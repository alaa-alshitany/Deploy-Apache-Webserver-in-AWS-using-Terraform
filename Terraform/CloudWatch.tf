# alarm for changing in auto scaling group state
resource "aws_cloudwatch_metric_alarm" "asg_state_change_alarm" {
  alarm_name          = "ASGStateChange"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "GroupTotalInstances"
  namespace           = "AWS/AutoScaling"
  period              = 300  
  statistic           = "Minimum"
  threshold           = 1    

  alarm_description = "Alarm triggered when ASG state changes"
  alarm_actions     = [aws_sns_topic.user_notifications.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web-scaling.name
  }
}

# alarm for average CPU utilization is > 80%
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  
  statistic           = "Average"
  threshold           = 80  

  alarm_description = "Alarm triggered when CPU utilization exceeds 80%"
  alarm_actions     = [aws_autoscaling_policy.scaling-out.arn, aws_autoscaling_policy.scaling-in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web-scaling.name
  }
}