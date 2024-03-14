data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.kinesis_stream_kms_key_arn == null ? [] : [var.kinesis_stream_kms_key_arn]
    content {
      sid    = "GenerateKinesisStreamKmsKey"
      effect = "Allow"

      actions = [
        "kms:GenerateDataKey"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "WriteToKinesisStream"
    effect = "Allow"

    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [var.kinesis_stream_arn]
  }
}
