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

resource "aws_route53_hosted_zone_dnssec" "this" {
  count          = var.dnssec_enabled ? 1 : 0
  hosted_zone_id = aws_route53_zone.this.zone_id
  depends_on     = [aws_route53_key_signing_key.dnssec[0]]
}

resource "aws_route53_key_signing_key" "dnssec" {
  count                      = var.dnssec_enabled ? 1 : 0
  name                       = var.domain_name
  hosted_zone_id             = aws_route53_zone.this.zone_id
  key_management_service_arn = aws_kms_key.dnssec[0].arn
}

resource "aws_kms_key" "dnssec" {
  count = var.dnssec_enabled ? 1 : 0

  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms_key_dnssec.json
}

data "aws_iam_policy_document" "kms_key_dnssec" {
  statement {
    sid     = "Allow Route 53 DNSSEC Service"
    effect  = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GetPublicKey",
      "kms:Sign",
    ]

    principals {
      type        = "Service"
      identifiers = [
        "dnssec-route53.amazonaws.com"
      ]
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid     = "Allow Route 53 DNSSEC Service to CreateGrant"
    effect  = "Allow"
    actions = [
      "kms:CreateGrant"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "dnssec-route53.amazonaws.com"
      ]
    }

    resources = [
      "*"
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    sid     = "IAM User Permissions"
    effect  = "Allow"
    actions = [
      "kms:*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["*"]
  }
}