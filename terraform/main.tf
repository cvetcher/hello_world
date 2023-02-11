provider "aws" {
  profile = "hello_world" 
  region = "eu-west-2"
}

data "aws_region" "current" {}

locals {
  database_name = var.app_name
  database_user = "rails"
}

module "vpc" {
  source = "./vpc"

  region = data.aws_region.current.name
}

module "database" {
  source                 = "./database"

  instance_class         = var.database_instance
  allocated_storage      = var.database_size

  database_name          = local.database_name
  database_user          = local.database_user

  db_subnet_group_name   = module.vpc.db_subnet_group_name
}

module "endpoint" {
  source                   = "./endpoint"

  load_balancer            = var.app_name
  target_group             = var.app_name

  vpc                      = module.vpc.vpc
  subnets                  = module.vpc.subnets

  healthcheck_path         = module.api_service.healthcheck_path
}

module "api_service" {
  source = "./api_service"

  region                   = data.aws_region.current.name
  cluster                  = var.app_name
  repository               = var.app_name

  container_cpu            = var.container_cpu
  container_ram            = var.container_ram

  database_host            = module.database.host
  database_name            = local.database_name
  database_user            = local.database_user
  database_password        = module.database.password

  target_group_arn         = module.endpoint.target_group_arn
  subnets                  = module.vpc.subnets
  vpc                      = module.vpc.vpc
  route_table              = module.vpc.route_table
}
