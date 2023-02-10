resource "aws_alb" "default" {
  name     = replace(var.load_balancer, "_", "-")
  subnets  = var.subnets
  security_groups    = [aws_security_group.lb.id]
}

locals {
  endpoint_port   = 80
}

resource "aws_security_group" "lb" {
  vpc_id      = var.vpc

  ingress {
    from_port        = local.endpoint_port
    to_port          = local.endpoint_port
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ "10.0.0.0/16" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "default" {
  name            = replace(var.target_group, "_", "-")

  target_type     = "ip"

  port            = local.endpoint_port
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
  port              = local.endpoint_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }
}

