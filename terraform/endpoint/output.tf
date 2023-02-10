
output "target_group_arn" {
  value = aws_alb_target_group.default.arn
}

output "dns_name" {
  value = aws_alb.default.dns_name
}
