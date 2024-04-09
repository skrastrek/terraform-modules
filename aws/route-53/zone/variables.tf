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

variable "tags" {
  type = map(string)
}
