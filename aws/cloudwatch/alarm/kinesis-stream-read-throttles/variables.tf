variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "Kinesis stream average read calls (GetRecords) throttled is too high."
}

variable "kinesis_stream_name" {
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
  description = "In fraction. (5% = 0.05)"
  type        = number
  default     = 0.05
}

variable "treat_missing_data" {
  description = ""
  type        = string
  default     = "ignore"
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