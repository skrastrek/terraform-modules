data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.dynamodb_table_kms_key_arn == null ? [] : [var.dynamodb_table_kms_key_arn]
    content {
      sid    = "DecryptDynamoDbKmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt"
      ]

      resources = [statement.value]
    }
  }
  statement {
    sid    = "ReadDynamoDbTable"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:BatchGetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:ConditionCheckItem"
    ]

    resources = [
      var.dynamodb_table_arn,
      "${var.dynamodb_table_arn}/index/*"
    ]
  }
}
