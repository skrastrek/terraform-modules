variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}

variable "sqs_queue_kms_key_arn" {
  type    = string
  default = null
}
