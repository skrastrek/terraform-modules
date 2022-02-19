resource "aws_iam_role" "ecs_task" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs_task_write_logs" {
  role   = aws_iam_role.ecs_task.id
  name   = "WriteLogs"
  policy = data.aws_iam_policy_document.write_logs.json
}

data "aws_iam_policy_document" "write_logs" {
  statement {
    effect = "Allow"
    resources = [
      var.log_group_arn
    ]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}