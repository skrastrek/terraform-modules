resource "aws_iam_role" "ecs_service_task" {
  name               = "${var.service_name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_task_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_service_task_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "ecs_service_task_write_logs" {
  role   = aws_iam_role.ecs_service_task.id
  name   = "WriteLogs"
  policy = data.aws_iam_policy_document.write_logs.json
}

data "aws_iam_policy_document" "write_logs" {
  statement {
    effect = "Allow"
    resources = [
      aws_cloudwatch_log_group.ecs_service.arn,
    ]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_role" "ecs_service_task_execution" {
  name               = "${var.service_name}-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_task_execution_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_service_task_execution_assume_role" {
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

resource "aws_iam_role_policy_attachment" "ecs_service_task_execution_amazon_ecs_task_execution" {
  role       = aws_iam_role.ecs_service_task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}