resource "aws_iam_role_policy" "this" {
  role   = var.role_id
  name   = "CloudWatchWriteLogs"
  policy = data.aws_iam_policy_document.cloudwatch_write_logs.json
}

data "aws_iam_policy_document" "cloudwatch_write_logs" {
  statement {
    effect    = "Allow"
    resources = var.log_group_arns
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}