resource "aws_lb" "app-ALB" {
  name               = "App-ALB"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  enable_deletion_protection = false
  internal = "false"
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.app-ALB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target-group.arn
    type             = "forward"
  }
}