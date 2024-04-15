resource "aws_route53_zone" "this" {
  name    = var.name
  comment = var.comment

  dynamic "vpc" {
    for_each = var.vpc_associations
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_key_signing_key" "dnssec" {
  count = var.dnssec_enabled ? 1 : 0

  name                       = aws_route53_zone.this.name
  hosted_zone_id             = aws_route53_zone.this.zone_id
  key_management_service_arn = var.dnssec_kms_key_arn
}

resource "aws_route53_hosted_zone_dnssec" "this" {
  count = var.dnssec_enabled ? 1 : 0

  hosted_zone_id = aws_route53_zone.this.zone_id

  depends_on = [aws_route53_key_signing_key.dnssec[0]]
}
