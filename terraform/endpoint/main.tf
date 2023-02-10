resource "aws_alb" "default" {
  name     = replace(var.load_balancer, "_", "-")
  subnets  = var.subnets
}

resource "aws_alb_target_group" "default" {
  name            = replace(var.target_group, "_", "-")

  target_type     = "ip"

  port            = 80
  protocol        = "HTTP"
  vpc_id          = var.vpc

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = var.healthcheck_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.default.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }
}

