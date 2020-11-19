locals {
  alb_name    = "ALB-${var.project_code}-${terraform.workspace}"
  gr_alb_name = "Gr-${local.alb_name}"
}

resource "aws_lb_target_group" "webserver" {
  name     = local.gr_alb_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.alb_stickiness_duration
    enabled         = var.alb_enable_stickiness
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 6
    path                = var.alb_health_check_path
    port                = "traffic-port"
    matcher             = "200"
  }

  tags = {
    Name      = local.gr_alb_name
    Stages    = terraform.workspace
    Project   = var.project
    Terraform = true
  }
}

resource "aws_lb" "front_end" {
  name               = local.alb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.sg_public.id]

  idle_timeout = 60

  tags = {
    Name      = local.alb_name
    Stages    = terraform.workspace
    Project   = var.project
    Terraform = true
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver.arn
  }
}
