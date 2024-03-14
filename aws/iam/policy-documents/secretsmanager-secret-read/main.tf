data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.secret_kms_key_arn == null ? [] : [var.secret_kms_key_arn]
    content {
      sid    = "DecryptSecretKmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "ReadSecretValue"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [var.secret_arn]
  }
}
