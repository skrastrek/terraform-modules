data "aws_lb" "this" {
  count = var.lb_arn == null ? 0 : 1
  arn   = var.lb_arn
}

resource "aws_lb_target_group" "ecs_service" {
  name = var.service_name

  vpc_id = var.vpc_id

  port             = var.task_host_port
  protocol         = var.task_host_protocol
  protocol_version = var.task_host_protocol_version

  target_type = "ip"

  health_check {
    enabled             = var.health_check.enabled
    protocol            = var.health_check.protocol
    port                = var.health_check.port
    path                = var.health_check.path
    matcher             = var.health_check.matcher
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  tags = var.tags
}