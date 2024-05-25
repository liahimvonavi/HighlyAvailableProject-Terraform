#Create EC2 Instances

resource "aws_launch_configuration" "ec2_launch_config" {
  image_id        = "ami-08188dffd130a1ac2" 
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2_grp.id]

  user_data = <<-EOL
  #!/bin/bash
  # Use this for your user data (script from top to bottom)
  # install httpd (Linux 2 version)
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOL

  lifecycle {
    create_before_destroy = true
  }

}

#Security Group EC2
resource "aws_security_group" "ec2_grp" {
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_grp.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #my ip  
  }  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
