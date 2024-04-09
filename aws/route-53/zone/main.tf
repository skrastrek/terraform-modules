data "aws_caller_identity" "current" {}

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

resource "aws_route53_hosted_zone_dnssec" "this" {
  count = var.dnssec_enabled ? 1 : 0

  hosted_zone_id = aws_route53_zone.this.zone_id
  depends_on     = [aws_route53_key_signing_key.dnssec[0]]
}

resource "aws_route53_key_signing_key" "dnssec" {
  count = var.dnssec_enabled ? 1 : 0

  name                       = aws_route53_zone.this.name
  hosted_zone_id             = aws_route53_zone.this.zone_id
  key_management_service_arn = aws_kms_key.dnssec[0].arn
}

resource "aws_kms_key" "dnssec" {
  count = var.dnssec_enabled ? 1 : 0

  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.kms_key_dnssec.json

  tags = var.tags
}

data "aws_iam_policy_document" "kms_key_dnssec" {
  statement {
    sid    = "IAM User Permissions"
    effect = "Allow"

    actions = ["kms:*"]

    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "Allow Route 53 DNSSEC Service"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:GetPublicKey",
      "kms:Sign",
    ]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow Route 53 DNSSEC Service to CreateGrant"
    effect = "Allow"

    actions = ["kms:CreateGrant"]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["dnssec-route53.amazonaws.com"]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}
