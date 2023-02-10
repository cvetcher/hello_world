
output "repository" {
  value = module.api_service.repository_url
}

output "endpoint" {
  value = module.endpoint.dns_name
}

output "cluster" {
  value = module.api_service.cluster
}

output "service" {
  value = module.api_service.service
}

