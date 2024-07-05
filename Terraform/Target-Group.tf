resource "aws_lb_target_group" "target-group" {
  name     = "webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web_vpc.id
  health_check {
    path = "/"
    interval = 30
    timeout = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}