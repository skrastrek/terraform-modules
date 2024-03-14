locals {
  enable_policy_allow_root_account      = var.allow_root_account_id != null
  enable_policy_allow_service_principal = length(var.allow_service_principals) > 0
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = flatten([
    local.enable_policy_allow_root_account ? [data.aws_iam_policy_document.allow_root_account[0].json] : [],
    local.enable_policy_allow_service_principal ? [data.aws_iam_policy_document.allow_service_principal[0].json] : []
  ])
}

data "aws_iam_policy_document" "allow_root_account" {
  count = local.enable_policy_allow_root_account ? 1 : 0

  statement {
    sid    = "AllowRootAccount"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.allow_root_account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "allow_service_principal" {
  count = local.enable_policy_allow_service_principal ? 1 : 0

  statement {
    sid    = "AllowService"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = var.allow_service_principals
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
}