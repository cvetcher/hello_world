
output "vpc" {
  value = aws_vpc.default.id
}

output "subnet1" {
  value = aws_subnet.subnet1.id
}

output "subnets" {
  value = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rds.name
}
