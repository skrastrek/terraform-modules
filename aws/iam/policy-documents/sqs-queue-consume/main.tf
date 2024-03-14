data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.sqs_queue_kms_key_arn == null ? [] : [var.sqs_queue_kms_key_arn]
    content {
      sid    = "DecryptSqsQueueKmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "ConsumeFromSqsQueue"
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [var.sqs_queue_arn]
  }
}
