output "name" {
  value = aws_ecs_service.this.name
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_service.arn
}

output "target_group_name" {
  value = aws_lb_target_group.ecs_service.name
}

output "security_group_id" {
  value = aws_security_group.ecs_service.id
}

output "task_iam_role_id" {
  value = aws_iam_role.ecs_service_task.id
}

output "task_execution_iam_role_id" {
  value = aws_iam_role.ecs_service_task_execution.id
}