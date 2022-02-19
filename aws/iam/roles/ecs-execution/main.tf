resource "aws_iam_role" "ecs_execution" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_execution_assume_role" {
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

resource "aws_iam_role_policy_attachment" "ecs_execution_amazon_ecs_task_execution" {
  role       = aws_iam_role.ecs_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}