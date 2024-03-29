resource "aws_iam_role" "github_actions_oidc" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_oidc_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "github_actions_oidc_assume_role" {
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
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [for entry in var.github_repositories : "repo:${entry.organization}/${entry.repository}:*"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_oidc" {
  count = length(var.iam_role_policy_attachments)

  role       = aws_iam_role.github_actions_oidc.id
  policy_arn = var.iam_role_policy_attachments[count.index]
}
