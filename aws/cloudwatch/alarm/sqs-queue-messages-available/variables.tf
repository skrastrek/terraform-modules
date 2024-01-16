variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "The number of messages available for retrieval is too high."
}

variable "sqs_queue_name" {
  description = ""
  type        = string
}

variable "period" {
  description = "In seconds."
  type        = number
  default     = 120
}

variable "evaluation_periods" {
  description = "Number of consecutive data points that breach the metric before an alarm is triggered."
  type        = number
  default     = 1
}

variable "threshold" {
  description = "Number of messages."
  type        = number
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