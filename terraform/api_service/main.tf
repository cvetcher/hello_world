resource "aws_ecs_cluster" "default" {
  name = var.cluster
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = var.cluster

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}


locals {
  container_name   = "rails"
  container_port   = 3000
  healthcheck_path = "/healthcheck/database"
}

resource "aws_ecs_service" "rails" {
  name            = "rails"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.rails.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = local.container_port
  }

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
	security_groups  = [ aws_security_group.container.id ]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            =  1
  }
}

resource "random_password" "secret_key_base" {
    length           = 32
    special          = false
}



resource "aws_ecs_task_definition" "rails" {
  family                   = "rails"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_ram
  network_mode             = "awsvpc"

  execution_role_arn       = aws_iam_role.task_execution_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = templatefile(
                                        "${path.module}/rails.json",
                                        {
                                          repository_url    = aws_ecr_repository.default.repository_url
                                          container_name    = local.container_name
                                          container_port    = local.container_port
                                          database_host     = var.database_host
                                          database_name     = var.database_name
                                          database_user     = var.database_user
                                          database_password = var.database_password
                                          region            = var.region
                                          cloudwatch_group  = aws_cloudwatch_log_group.rails.name
                                          secret_key_base   = random_password.secret_key_base.result
                                        }
                                      )

}

resource "aws_ecr_repository" "default" {
  name = var.repository
  image_tag_mutability = "MUTABLE"
}


resource "aws_cloudwatch_log_group" "rails" {
  name = "/ecs/${local.container_name}"
}

resource "aws_security_group" "container" {
  vpc_id      = var.vpc

  ingress {
    from_port        = local.container_port
    to_port          = local.container_port
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

