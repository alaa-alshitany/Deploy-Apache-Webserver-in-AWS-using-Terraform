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
