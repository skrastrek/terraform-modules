variable "github_account_name" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_actions_iam_oidc_provider_arn" {
  type = string
}

variable "iam_role_name" {
  type = string
}

variable "iam_role_policy_attachments" {
  type = set(string)
}

variable "tags" {
  type = map(string)
}