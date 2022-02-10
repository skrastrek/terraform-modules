module "github_actions_oidc_provider" {
  source = "../../iam/oidc-providers/github-actions"
  tags   = var.tags
}

module "github_actions_oidc_iam_role" {
  for_each = var.github_actions_oidc_iam_roles

  source = "../../iam/roles/github-actions-oidc"

  github_account_name = each.value.github_account_name
  github_repository_name = each.value.github_repository_name
  github_actions_iam_oidc_provider_arn = module.github_actions_oidc_provider.arn

  iam_role_name = each.value.iam_role_name
  iam_role_policy_attachments = each.value.iam_role_policy_attachments

  tags = var.tags
}