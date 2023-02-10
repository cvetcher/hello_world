
output "repository_url" {
  value = aws_ecr_repository.default.repository_url
}

output "cluster" {
  value = aws_ecs_cluster.default.name
}

output "service" {
  value = aws_ecs_service.rails.name
}

output "healthcheck_path" {
  value = local.healthcheck_path
}
