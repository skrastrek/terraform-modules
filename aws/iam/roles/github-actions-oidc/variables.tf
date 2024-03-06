variable "github_actions_iam_oidc_provider_arn" {
  type = string
}

variable "github_repositories" {
  type = list(object({
    organization = string
    repository   = string
  }))
}

variable "iam_role_name" {
  type = string
}

variable "iam_role_policy_attachments" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}