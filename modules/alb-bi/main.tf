resource "aws_lb" "bi_alb" {
  name               = "${var.project_name}-bi-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_sg_id]
  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "${var.project_name}-bi-alb"
  }
}

resource "aws_lb_target_group" "bi_tg" {
  name        = "${var.project_name}-bi-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-bi-tg"
  }
}

resource "aws_lb_target_group_attachment" "bi_attach" {
  target_group_arn = aws_lb_target_group.bi_tg.arn
  target_id        = var.instance_id
  port             = 3000
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.bi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.bi_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bi_tg.arn
  }
}
