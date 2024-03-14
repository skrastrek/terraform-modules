variable "sns_topic_arn" {
  type = string
}

variable "sns_topic_kms_key_arn" {
  type    = string
  default = null
}