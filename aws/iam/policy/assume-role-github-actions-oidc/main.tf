data "aws_iam_policy_document" "assume_role_github_actions_oidc" {
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