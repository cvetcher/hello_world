
resource "random_password" "password" {
  length           = 32
  special          = false
}

resource "aws_db_instance" "default" {
  engine                 = "mysql"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.database_name
  username               = var.database_user
  password               = random_password.password.result
  skip_final_snapshot    = true
  db_subnet_group_name   = var.db_subnet_group_name
}
