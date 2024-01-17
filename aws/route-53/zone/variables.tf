variable "domain_name" {
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

variable "records" {
  type = map(object({
    type    = string
    name    = string
    records = list(string)
    ttl     = number
  }))
  default = {}
}

variable "dnssec_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}
