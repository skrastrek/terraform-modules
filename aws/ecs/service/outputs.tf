output "name" {
  value = aws_ecs_service.service.name
}

output "desired_count" {
  value = aws_ecs_service.service.desired_count
}