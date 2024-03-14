data "aws_iam_policy_document" "this" {
  statement {
    effect    = "Allow"
    actions   = ["kms:Describe", "kms:Sign"]
    resources = [var.kms_key_arn]
  }
}
