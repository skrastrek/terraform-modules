variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "Lambda function average duration is too high."
}

variable "lambda_function_name" {
  description = ""
  type        = string
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
  description = "In milliseconds."
  type        = number
  default     = 200
}

variable "treat_missing_data" {
  description = ""
  type        = string
  default     = "missing"
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