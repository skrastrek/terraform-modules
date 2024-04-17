variable "role_name" {
  type = string
}

variable "policy_name" {
  type    = string
  default = "cloudwatch-logs-write"
}

variable "log_group_arns" {
  type = list(string)
}