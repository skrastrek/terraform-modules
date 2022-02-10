resource "aws_iam_role" "github_actions" {
  name = var.iam_role_name
  assume_role_policy = module.github_actions_oidc_iam_assume_role_policy.json
  tags = var.tags
}

module "github_actions_oidc_iam_assume_role_policy" {
  source = "../../policy/assume-role-github-actions-oidc"

  github_account_name = var.github_account_name
  github_repository_name = var.github_repository_name
  github_actions_iam_oidc_provider_arn = module.github_actions_iam_oidc_provider.arn
}

module "github_actions_iam_oidc_provider" {
  source = "../../oidc-provider/github-actions"

  tags = var.tags
}