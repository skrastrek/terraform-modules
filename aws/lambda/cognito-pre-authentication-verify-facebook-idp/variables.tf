variable "name" {
  type = string
}

variable "cloudwatch_logs_retention_in_days" {
  type = number
}

variable "cloudwatch_logs_kms_key_id" {
  type    = string
  default = null
}

variable "memory_size" {
  type = number
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

variable "tags" {
  type = map(string)
}
