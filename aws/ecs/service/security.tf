locals {
  lb_security_groups = toset(flatten([for key, value in var.load_balancers : data.aws_lb.this[key].security_groups]))
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  name        = var.name
  description = "ECS service security group"
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

resource "aws_security_group_rule" "this_ingress_lb" {
  for_each                 = local.lb_security_groups
  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = each.value
  description              = "Ingress from load balancer."
}