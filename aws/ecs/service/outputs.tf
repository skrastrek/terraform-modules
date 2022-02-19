output "name" {
  value = aws_ecs_service.this.name
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