variable "function_name" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "cognito_user_pool_id" {
  type = string
}

variable "cognito_user_pool_region_id" {
  type = string
}

variable "cognito_user_pool_client_id" {
  type = string
}

variable "cognito_user_pool_domain" {
  type = string
}

variable "callback_path" {
  type = string
}

variable "logout_path" {
  type = string
}

variable "logout_redirect_path" {
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
