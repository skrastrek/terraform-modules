data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.s3_bucket_kms_key_arn == null ? [] : [var.s3_bucket_kms_key_arn]
    content {
      sid    = "GenerateS3KmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "GetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]
    resources = ["${var.s3_access_point_arn}/object/*"]
  }
}
