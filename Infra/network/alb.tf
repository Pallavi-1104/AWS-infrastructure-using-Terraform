resource "aws_lb" "app_alb" {
  name               = "ecs-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.efs_sg.id]
  subnets            = aws_subnet.public[*].id

  tags = {
    Name = "ecs-app-alb"
  }
}

resource "aws_lb_target_group" "nodejs_tg" {
  name     = "nodejs-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "nodejs-tg"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodejs_tg.arn
  }
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

