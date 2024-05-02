variable "name" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "jwt_audience" {
  type = list(string)
}

variable "jwt_issuer" {
  type = string
}

variable "jwt_scope" {
  type = string
}

variable "jwt_source_header_name" {
  type    = string
  default = "Authorization"
}

variable "jwt_source_cookie_regex" {
  type = string
}

variable "jwt_cognito_client_id" {
  type    = list(string)
  default = null
}

variable "jwt_cognito_group" {
  type    = list(string)
  default = null
}

variable "jwt_cognito_token_use" {
  type    = string
  default = null

  validation {
    condition     = var.jwt_cognito_token_use == "access" || var.jwt_cognito_token_use == "id" || var.jwt_cognito_token_use == null
    error_message = "jwt_cognito_token_use value must be either 'access', 'id' or null"
  }
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
