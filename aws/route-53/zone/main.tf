resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = var.comment
}

resource "aws_route53_record" "this" {

  for_each = {
    for record in var.records : "${record.name}_${record.type}" => record
  }

  zone_id = aws_route53_zone.this.id
  name    = each.value.name
  type    = each.value.type
  records = each.value.records
  ttl     = each.value.ttl
}