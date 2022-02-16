resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = var.comment
}

resource "aws_route53_record" "this" {
  zone_id  = aws_route53_zone.this.id
  for_each = var.records
  name     = each.value.name
  type     = each.value.type
  records  = each.value.records
  ttl      = each.value.ttl
}