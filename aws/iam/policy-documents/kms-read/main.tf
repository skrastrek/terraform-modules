data "aws_iam_policy_document" "kms_read" {
  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = var.kms_key_arns
  }
}
