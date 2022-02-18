resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name        = var.service_name
  description = "ECS service security group"
  tags        = var.tags
}

resource "aws_security_group_rule" "ecs_service_egress" {
  security_group_id = aws_security_group.ecs_service.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ecs_service_ingress_lb" {
  for_each                 = var.lb_arn == null ? [] : data.aws_lb.this[1].security_groups
  security_group_id        = aws_security_group.ecs_service.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = each.value
  description              = "Ingress from load balancer."
}