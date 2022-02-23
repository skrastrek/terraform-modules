resource "aws_security_group" "alb" {
  vpc_id      = var.vpc_id
  name        = "${var.name}-lb"
  description = "Application Load Balancer."
  tags        = var.tags
}

resource "aws_security_group_rule" "alb_inbound_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = var.inbound_cidr_blocks
}

resource "aws_security_group_rule" "alb_inbound_https" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "TCP"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.inbound_cidr_blocks
}