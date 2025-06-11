resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_sg_id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# HTTP → HTTPS Redirect
resource "aws_lb_listener" "http" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.app_alb.arn

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" { 
  port              = 443
  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.acm_certificate_arn
  load_balancer_arn = aws_lb.app_alb.arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}
