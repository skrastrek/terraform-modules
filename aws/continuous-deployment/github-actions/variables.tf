variable "github_actions_oidc_iam_roles" {
  type = map(object({
    github_account_name = string
    github_repository_name = string
    iam_role_name = string
    iam_role_policy_attachments = set(string)
  }))
}

variable "tags" {
  type = map(string)
}