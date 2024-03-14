data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.sqs_queue_kms_key_arn == null ? [] : [var.sqs_queue_kms_key_arn]
    content {
      sid    = "GenerateSqsQueueKmsKey"
      effect = "Allow"

      actions = [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "SendToSqsQueue"
    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]
    resources = [var.sqs_queue_arn]
  }
}
