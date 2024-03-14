data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.dynamodb_table_kms_key_arn == null ? [] : [var.dynamodb_table_kms_key_arn]
    content {
      sid    = "UseDynamoDbKmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ]

      resources = [statement.value]
    }
  }
  statement {
    sid    = "WriteDynamoDbTable"
    effect = "Allow"

    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      var.dynamodb_table_arn,
      "${var.dynamodb_table_arn}/index/*"
    ]
  }
}