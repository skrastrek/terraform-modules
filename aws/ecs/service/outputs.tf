output "name" {
  value = aws_ecs_service.this.name
}

output "task_role_id" {
  value = module.ecs_task_role.id
}

output "task_execution_role_id" {
  value = module.ecs_task_execution_role.id
}

output "lb_target_groups" {
  value = {
    for key, value in aws_lb_target_group.this : key => {
      arn  = value.arn
      name = value.name
    }
  }
}

output "security_group_id" {
  value = aws_security_group.this.id
}