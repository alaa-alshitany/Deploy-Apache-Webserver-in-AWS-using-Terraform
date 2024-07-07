resource "aws_route53_zone" "primary" {
  name = "DeployApache.com"
}

resource "aws_route53_record" "record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "DeployApache.com"
  type    = "A"
  alias {
    name                   = aws_lb.app-ALB.dns_name
    zone_id                = aws_lb.app-ALB.zone_id
    evaluate_target_health = true
  }
}

