data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  description = var.description

  deletion_window_in_days = var.deletion_window_in_days

  policy = data.aws_iam_policy_document.resource_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "resource_policy" {
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