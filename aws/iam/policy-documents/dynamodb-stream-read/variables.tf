variable "dynamodb_stream_arn" {
  type = string
}

variable "dynamodb_table_kms_key_arn" {
  type    = string
  default = null
}