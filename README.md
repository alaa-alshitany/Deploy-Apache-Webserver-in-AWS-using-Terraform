# Deploy Apache Web Server using Terraform IaC

## 📝 Overview
This project aims to deploy Apache Webserver in AWS cloud using Terraform as IaC.


![webserver](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/assets/71197108/711eb419-8a9e-44b4-bf7b-2fdbcd2bfcab)

---

## 📋 Prerequisites
1- Create below resources using  Terraform IaC
- Create S3 Bucket to store the terraform statefiles
    
    ```
    resource "aws_s3_bucket" "bk" {
        bucket = "YOUR BUCKET NAME"
        tags = {
            Name        = "YOUR BUCKET NAME"
        }
    }
    ```
---
- Create DynamoDB
    
    ```
    resource "aws_dynamodb_table" "dynamo_tb" {
        name           = "YOUR TABLE NAME"
        read_capacity  = 10
        write_capacity = 10
        hash_key = "LockID"
        attribute {
            name = "LockID"
            type = "S"
        }
    }
    ```

2- Deploy VPC Network using Terrafom IaC and keep the state file in S3 backend.

create [Network Module](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/tree/main/Terraform/Network)

---

3- Create below resources using Terraform IaC and keep the state file in S3 backend
- S3 Bucket to store the webserver configuration and PUT  [user-data.sh](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/blob/main/Scripts/user-data.sh)  script file which will configure webserver.

  ```
   resource "aws_s3_bucket" "bk" {
        bucket = "YOUR BUCKET NAME"
        tags = {
            Name        = "YOUR BUCKET NAME"
        }
    }
  ```
  
- SNS topic for notifications

  ```
  resource "aws_sns_topic" "user_notifications" {
  name = "YOUR SNS NAME"
  }
  ```

- IAM Role

```
resource "aws_iam_role" "Terraform_Role" {
  name = "YOUR ROLE NAME"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
```
4- Golden AMI
-First create EC2 on AWS and get the instance ID.

```
resource "aws_ami_from_instance" "golden_ami" {
  name = "YOUR AMI NAME"
  source_instance_id = "YOUR INSATNCE ID"
}
```
---

## 🚀 Deployment
1- Create  [IAM Role](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/blob/main/Terraform/IAM-Role.tf) granting PUT/GET  access to S3 Bucket and Session Manager access.

---

2- Create [Launch Configuration](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/blob/main/Terraform/launch-temp.tf) with userdata script to pull the use-data.sh file from S3 and attach IAM role and [user-data.sh will configure the webserver].

---

3- Create Auto Scaling Group with Min:1 Max: 1 Des: 1  in private subnet.

```
resource "aws_autoscaling_group" "web-scaling" {
  name                      = "YOUR ASG NAME"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier = "YOUR AZS ID"

  launch_template {
    id = "YOUR LAUNCH TEMP ID"
  }
  target_group_arns = ["YOUR TARGET GROUP ARN"]
}
```
---

4- Create Target Group with health checks to and attach with Auto Scaling Group

```
resource "aws_lb_target_group" "target-group" {
  name     = "YOUR TARGET GROUP NAME"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "YOUR VPC ID"
  health_check {
    path = "/"
    interval = 10
    timeout = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
```
---

5- Create Application Load balancer in public subnet and configure Listener Port to route the traffic to the Target Group.

```
resource "aws_lb" "app-ALB" {
  name               = "YOUR LOAD BALANCER NAME"
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
```
---

6- Create alias record in Hosted Zone to route the traffic to the Load balancer from public network.

```
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
```
---

7- Create Cloudwatch Alarms to send notification when ASG state changes.

```
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
```
---

8- Create Scaling Policies to scale out/Scale In when average CPU utilization is > 80%

```
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
```
---

### Deploy Terraform IaC to create the resources
```
terraform init
terraform plan
terraform apply
```
---

![Screenshot from 2024-07-07 21-25-50](https://github.com/alaa-alshitany/Deploy-Apache-Webserver-in-AWS-using-Terraform/assets/71197108/6da9476d-9603-4856-a7a5-38911a886713)
