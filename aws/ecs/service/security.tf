locals {
  lb_security_groups = toset(flatten([for key, value in var.load_balancers : data.aws_lb.this[key].security_groups]))
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-service"
  description = "ECS service."
  tags        = var.tags
}

resource "aws_security_group_rule" "this_egress" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "this_ingress_lb_container" {
  for_each                 = local.lb_security_groups
  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = var.task_container_port
  to_port                  = var.task_container_port
  source_security_group_id = each.value
  description              = "Allow inbound traffic from load balancer on task container port."
}

resource "aws_security_group_rule" "this_ingress_lb_health_check" {
  for_each                 = var.task_health_check.port == "traffic-port" ? [] : local.lb_security_groups
  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  protocol                 = "TCP"
  from_port                = tonumber(var.task_health_check.port)
  to_port                  = tonumber(var.task_health_check.port)
  source_security_group_id = each.value
  description              = "Allow inbound traffic from load balancer on task health check port."
}

resource "aws_security_group_rule" "lb_egress_service_task_container" {
  for_each                 = local.lb_security_groups
  security_group_id        = each.value
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = var.task_container_port
  to_port                  = var.task_container_port
  source_security_group_id = aws_security_group.this.id
  description              = "Allow outbound traffic to ${aws_security_group.this.name} on task container port."
}

resource "aws_security_group_rule" "lb_egress_service_task_health_check" {
  for_each                 = var.task_health_check.port == "traffic-port" ? [] : local.lb_security_groups
  security_group_id        = each.value
  type                     = "egress"
  protocol                 = "TCP"
  from_port                = tonumber(var.task_health_check.port)
  to_port                  = tonumber(var.task_health_check.port)
  source_security_group_id = aws_security_group.this.id
  description              = "Allow outbound traffic to ${aws_security_group.this.name} on task health check port."
}