 
 

 

resource "aws_lb" "public_nlb" {
  name               = "public-nlb"
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "Public NLB"
  }
}

resource "aws_lb_target_group" "public_nlb_target_group" {
  name     = "public-nlb-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    protocol = "TCP"
    port     = 80
  }
}

resource "aws_lb_listener" "public_nlb_listener" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_nlb_target_group.arn
  }
}

# Define an Auto Scaling Group and launch configuration for EC2 instances

resource "aws_launch_configuration" "as_conf" {
  name          = "lc_config"
  image_id      = "your_ami_id"  # Specify your desired AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  min_size             = 1
  max_size             = 4
  launch_configuration = aws_launch_configuration.as_conf.name
  vpc_zone_identifier  = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

# Attach the ASG instances to the NLB target group

resource "aws_lb_target_group_attachment" "public_nlb_attachment" {
  target_group_arn = aws_lb_target_group.public_nlb_target_group.arn
  target_id        = aws_autoscaling_group.asg.id
  port             = 80
}
