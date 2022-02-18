resource "aws_cloudwatch_log_group" "ecs_service" {
  name              = var.service_name
  retention_in_days = var.log_group_retention_in_days
  tags              = var.tags
}