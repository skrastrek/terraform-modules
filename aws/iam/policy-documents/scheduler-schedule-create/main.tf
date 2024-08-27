data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["scheduler:CreateSchedule"]
    resources = [
      var.scheduler_schedule_arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      var.scheduler_schedule_execution_role_arn
    ]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["scheduler.amazonaws.com"]
    }
  }
}
