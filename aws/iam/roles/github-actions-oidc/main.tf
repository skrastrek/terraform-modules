resource "aws_iam_role" "github_actions_oidc" {
  name                 = var.name
  description          = var.description
  permissions_boundary = var.permission_boundary
  assume_role_policy   = module.github_actions_oidc_iam_assume_role_policy_document.json

  tags = var.tags
}

module "github_actions_oidc_iam_assume_role_policy_document" {
  source = "../../policy-documents/github-actions-oidc-assume-role"

  github_actions_iam_oidc_provider_arn = var.github_actions_iam_oidc_provider_arn
  github_repositories                  = var.github_repositories
}

resource "aws_iam_role_policy_attachment" "github_actions_oidc" {
  count = length(var.policy_attachments)

  role       = aws_iam_role.github_actions_oidc.id
  policy_arn = var.policy_attachments[count.index]
}
