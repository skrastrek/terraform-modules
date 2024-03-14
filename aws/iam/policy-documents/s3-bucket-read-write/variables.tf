variable "s3_bucket_arn" {
  type = string
}

variable "s3_bucket_kms_key_arn" {
  type    = string
  default = null
}
