variable "name" {
  type = string
}

variable "comment" {
  type    = string
  default = ""
}

variable "vpc_associations" {
  type = list(object({
    vpc_id     = string
    vpc_region = string
  }))
  default = []
}

variable "dnssec_enabled" {
  type    = bool
  default = false
}

variable "dnssec_kms_key_arn" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}
