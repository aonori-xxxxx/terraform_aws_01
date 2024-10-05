# - - - - - - - - - - - - - -
# ALB
# - - - - - - - - - - - - - -

resource "aws_lb" "alb" {
  name               = "${var.project}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web_sg.id

  ]
  subnets = [aws_subnet.public_1a.id,
    aws_subnet.public_1c.id,
    aws_subnet.public_1d.id
  ]
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn

  }
}

# - - - - - - - - - - - - - -
# target group
# - - - - - - - - - - - - - -

resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.project}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-web-tg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.id
  target_id        = aws_instance.web_server2.id

}


