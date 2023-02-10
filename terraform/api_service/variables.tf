variable "region" {
}

variable "cluster" {
}

variable "repository" {
}

variable "container_ram" {
  type = number
}

variable "container_cpu" {
  type = number
}

variable "database_host" {
}

variable "database_name" {
}

variable "database_user" {
}

variable "database_password" {
}

variable "target_group_arn" {
}

variable "subnets" {
  type = list
}
