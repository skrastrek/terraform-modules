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

variable "logging_config" {
  type = object({
    log_format            = optional(string, "JSON")
    application_log_level = optional(string, "INFO")
    system_log_level      = optional(string, "WARN")
  })
  default = {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "WARN"
  }
}

variable "memory_size" {
  type = number
}

variable "tags" {
  type = map(string)
}
