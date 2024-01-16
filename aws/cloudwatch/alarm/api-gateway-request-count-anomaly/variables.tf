variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "API Gateway number of invocations is suspiciously high."
}

variable "api_gateway_name" {
  description = ""
  type        = string
}

variable "api_gateway_method" {
  description = "Requires detailed CloudWatch Metrics enabled on API Gateway."
  type        = string
  default     = null
}

variable "api_gateway_resource" {
  description = "Requires detailed CloudWatch Metrics enabled on API Gateway."
  type        = string
  default     = null
}

variable "api_gateway_stage_name" {
  description = "Requires detailed CloudWatch Metrics enabled on API Gateway."
  type        = string
  default     = null
}

variable "period" {
  description = "In seconds."
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = ""
  type        = number
  default     = 5
}

variable "threshold" {
  description = "Number of standard deviations away from the norm."
  type        = number
  default     = 5
}

variable "comparison_operator" {
  description = "GreaterThanUpperThreshold, LessThanLowerThreshold, or LessThanLowerOrGreaterThanUpperThreshold"
  type        = string
  default     = "LessThanLowerOrGreaterThanUpperThreshold"
}

variable "treat_missing_data" {
  description = ""
  type        = string
  default     = "notBreaching"
}

variable "ok_actions" {
  description = ""
  type        = list(string)
  default     = []
}

variable "alarm_actions" {
  description = ""
  type        = list(string)
  default     = []
}

variable "insufficient_data_actions" {
  description = ""
  type        = list(string)
  default     = []
}

variable "tags" {
  description = ""
  type        = map(string)
}
