variable "kinesis_stream_arn" {
  type = string
}

variable "kinesis_stream_kms_key_arn" {
  type    = string
  default = null
}