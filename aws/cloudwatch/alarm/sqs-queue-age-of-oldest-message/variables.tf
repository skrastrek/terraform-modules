variable "alarm_name" {
  description = ""
  type        = string
  default     = null
}

variable "alarm_description" {
  description = ""
  type        = string
  default     = "The age of the oldest message in queue is too high."
}

variable "sqs_queue_name" {
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
  default     = 10
}

variable "threshold" {
  description = "In seconds."
  type        = number
  default     = 300
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