data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      "${var.log_group_arn}:*",
      "${var.log_group_arn}:*:*"
    ]
  }
}
