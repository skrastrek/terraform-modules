variable "github_actions_iam_oidc_provider_arn" {
  type = string
}

variable "github_repositories" {
  type = list(object({
    organization = string
    repository   = string
  }))
}
