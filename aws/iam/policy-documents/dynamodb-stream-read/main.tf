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
    sid    = "ReadDynamoDbStream"
    effect = "Allow"

    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams"
    ]
    resources = [var.dynamodb_stream_arn]
  }
}
