variable "alarm_name" {
  type    = string
  default = null
}

variable "alarm_description" {
  type    = string
  default = "The number of replication failures is too high."
}

variable "source_s3_bucket_name" {
  type = string
}

variable "destination_s3_bucket_name" {
  type = string
}

variable "source_s3_bucket_replication_rule_id" {
  type = string
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
  description = "Number of replication failures."
  type        = number
}

variable "treat_missing_data" {
  type    = string
  default = "notBreaching"
}

variable "ok_actions" {
  type    = list(string)
  default = []
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "insufficient_data_actions" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(string)
}
