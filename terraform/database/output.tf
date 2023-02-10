output "host" {
  value = aws_db_instance.default.address
}

output "password" {
  value = aws_db_instance.default.password
}
