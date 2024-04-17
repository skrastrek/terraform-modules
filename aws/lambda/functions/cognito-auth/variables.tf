variable "function_name" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "cognito_user_pool_arn" {
  type = string
}

variable "cognito_user_pool_client_id" {
  type = string
}

variable "cognito_user_pool_domain" {
  type = string
}

variable "cloudwatch_logs_retention_in_days" {
  type = number
}

variable "cloudwatch_logs_kms_key_id" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}
