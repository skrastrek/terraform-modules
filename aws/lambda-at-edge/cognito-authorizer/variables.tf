variable "name" {
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

variable "cognito_user_pool_client_secret" {
  type      = string
  sensitive = true
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

variable "logging_config" {
  type = object({
    log_format            = string
    application_log_level = string
    system_log_level      = string
  })
  default = {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "INFO"
  }
}

variable "cookie_domain" {
  type = string
}

variable "cookie_path" {
  type = string
}

variable "cookie_same_site" {
  type = string

  validation {
    condition     = var.cookie_same_site == "Strict" || var.cookie_same_site == "Lax" || var.cookie_same_site == "None"
    error_message = "cookie_same_site value must be either 'Strict', 'Lax' or 'None'"
  }
}

variable "cookie_http_only" {
  type = bool
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
