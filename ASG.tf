#Create ASG
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
  launch_configuration = aws_launch_configuration.ec2_launch_config.id

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

#Scaling Policy
resource "aws_autoscaling_policy" "TargetTrackingPolicy" {
  name                   = "TargetTrackingPolicy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}

#Attach ASg to TG
resource "aws_autoscaling_attachment" "asg_attachement" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}
