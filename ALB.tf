#Create ALB
resource "aws_lb" "alb_web" {
  name               = "WebALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_grp.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}
#Security GRoup ALB
resource "aws_security_group" "alb_grp" {
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#Target Group ALB
resource "aws_lb_target_group" "alb_tg" {
  name     = "ALBTg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod-vpc.id

 health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}
#ALB Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
