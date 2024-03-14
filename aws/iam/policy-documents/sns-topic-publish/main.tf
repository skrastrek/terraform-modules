data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.sns_topic_kms_key_arn == null ? [] : [var.sns_topic_kms_key_arn]
    content {
      sid    = "DecryptSnsTopicKmsKey"
      effect = "Allow"

      actions = [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "PublishToSnsTopic"
    effect = "Allow"

    actions = [
      "sns:Publish"
    ]
    resources = [var.sns_topic_arn]
  }
}
