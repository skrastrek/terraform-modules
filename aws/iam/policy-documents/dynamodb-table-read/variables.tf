variable "dynamodb_table_arn" {
  type = string
}

variable "dynamodb_table_kms_key_arn" {
  type    = string
  default = null
}