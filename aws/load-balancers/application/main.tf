resource "aws_alb" "this" {
  name = var.name

  load_balancer_type = "application"

  subnets = var.subnet_ids

  security_groups = [
    aws_security_group.alb.id
  ]

  internal = var.internal

  idle_timeout = var.idle_timeout_in_seconds

  enable_http2               = var.enable_http2
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn

  protocol = "HTTP"
  port     = 80

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  tags = var.tags
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.this.arn

  protocol = "HTTPS"
  port     = 443

  ssl_policy      = var.ssl_policy
  certificate_arn = var.default_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "404"
      content_type = "application/json"
    }
  }

  tags = var.tags
}

resource "aws_alb_listener_certificate" "https" {
  for_each        = var.additional_certificate_arns
  listener_arn    = aws_alb_listener.https.arn
  certificate_arn = each.value
}
