data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.s3_bucket_kms_key_arn == null ? [] : [var.s3_bucket_kms_key_arn]
    content {
      sid    = "GenerateS3KmsKey"
      effect = "Allow"

      actions = [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject"
    ]
    resources = ["${var.s3_bucket_arn}/*"]
  }
}
