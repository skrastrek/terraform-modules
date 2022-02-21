variable "domain_name" {
  type = string
}

variable "comment" {
  type    = string
  default = ""
}

variable "records" {
  type = list(object({
    type    = string
    name    = string
    records = list(string)
    ttl     = number
  }))
  default = []
}

variable "dnssec_enabled" {
  type    = bool
  default = false
}