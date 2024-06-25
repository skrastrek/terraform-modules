variable "account_id" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "project_id" {
  type = string
}

variable "iam_member_roles" {
  type    = list(string)
  default = []
}

variable "github_iam_workload_identity_pool_name" {
  type = string
}

variable "github_repository" {
  type = string
}
