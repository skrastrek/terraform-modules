module "github_actions_oidc_provider" {
  source = "../iam/oidc-providers/github-actions"
  tags   = var.tags
}

module "github_actions_oidc_iam_role" {
  for_each = var.iam_roles

  source = "../iam/roles/github-actions-oidc"

  github_organization                  = each.value.github_organization
  github_repository                    = each.value.github_repository
  github_actions_iam_oidc_provider_arn = module.github_actions_oidc_provider.arn

  iam_role_name               = each.value.iam_role_name
  iam_role_policy_attachments = each.value.iam_role_policy_attachments

  tags = var.tags
}