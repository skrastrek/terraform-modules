variable "domain_name" {
  type        = string
}

variable "comment" {
  type    = string
  default = ""
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