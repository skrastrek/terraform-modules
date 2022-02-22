data "aws_lb" "this" {
  for_each = var.load_balancers
  arn      = each.value.arn
}

resource "aws_lb_target_group" "this" {
  for_each = var.load_balancers
  name     = "${data.aws_lb.this[each.key].name}-${var.name}"

  vpc_id = var.vpc_id

  port             = var.task_port
  protocol         = var.task_protocol
  protocol_version = var.task_protocol_version

  target_type = "ip"

  health_check {
    enabled             = var.task_health_check.enabled
    protocol            = var.task_health_check.protocol
    port                = var.task_health_check.port
    path                = var.task_health_check.path
    matcher             = var.task_health_check.matcher
    timeout             = var.task_health_check.timeout
    interval            = var.task_health_check.interval
    healthy_threshold   = var.task_health_check.healthy_threshold
    unhealthy_threshold = var.task_health_check.unhealthy_threshold
  }

  tags = var.tags
}