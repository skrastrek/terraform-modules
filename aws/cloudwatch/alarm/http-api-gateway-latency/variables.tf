variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "API Gateway average latency is too high."
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
  default     = 10
}

variable "threshold" {
  description = "In milliseconds."
  type        = number
  default     = 5000
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
