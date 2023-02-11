
resource "aws_vpc_endpoint" "s3" {
  vpc_id               = var.vpc
  vpc_endpoint_type    = "Gateway"
  route_table_ids      = [var.route_table]
  service_name         = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint" "dkr" {
  vpc_id               = var.vpc
  subnet_ids           = var.subnets
  vpc_endpoint_type    = "Interface"
  private_dns_enabled  = true
  service_name         = "com.amazonaws.${var.region}.ecr.dkr"
  security_group_ids   = [aws_security_group.vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "api" {
  vpc_id               = var.vpc
  subnet_ids           = var.subnets
  vpc_endpoint_type    = "Interface"
  private_dns_enabled  = true
  service_name         = "com.amazonaws.${var.region}.ecr.api"
  security_group_ids   = [aws_security_group.vpc_endpoint.id]
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id               = var.vpc
  subnet_ids           = var.subnets
  vpc_endpoint_type    = "Interface"
  private_dns_enabled  = true
  service_name         = "com.amazonaws.${var.region}.logs"
  security_group_ids   = [aws_security_group.vpc_endpoint.id]
}


resource "aws_security_group" "vpc_endpoint" {
  vpc_id      = var.vpc

  ingress {
    from_port        = 443
    to_port          = 443
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

