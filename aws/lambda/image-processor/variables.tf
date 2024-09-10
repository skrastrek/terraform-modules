variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "cloudwatch_log_group_retention_in_days" {
  type = number
}

variable "cloudwatch_log_group_kms_key_id" {
  type    = string
  default = null
}

variable "image_cache_control" {
  type = string
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

variable "timeout" {
  type    = number
  default = 20
}

variable "default_image_fit" {
  type    = string
  default = "inside"
}

variable "default_image_quality" {
  type    = number
  default = 80
}

variable "query_param_image_fit" {
  type    = string
  default = "fit"
}

variable "query_param_image_height" {
  type    = string
  default = "height"
}

variable "query_param_image_width" {
  type    = string
  default = "width"
}

variable "query_param_image_quality" {
  type    = string
  default = "quality"
}

variable "tags" {
  type = map(string)
}
