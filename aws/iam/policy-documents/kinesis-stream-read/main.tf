data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.kinesis_stream_kms_key_arn == null ? [] : [var.kinesis_stream_kms_key_arn]
    content {
      sid    = "DecryptKinesisStreamKmsKey"
      effect = "Allow"

      actions = [
        "kms:Decrypt"
      ]
      resources = [statement.value]
    }
  }
  statement {
    sid    = "ReadFromKinesisStream"
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:SubscribeToShard"
    ]
    resources = [var.kinesis_stream_arn]
  }
}
