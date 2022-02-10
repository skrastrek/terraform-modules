resource "aws_iam_role" "github_actions" {
  name = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  tags = var.tags
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type = "Federated"
      identifiers = [
        var.github_actions_iam_oidc_provider_arn
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_account_name}/${var.github_repository_name}:*"
      ]
    }
  }
}