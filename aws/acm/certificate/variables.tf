variable "zone_id" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "validation_enabled" {
  type    = bool
  default = true
}

variable "validation_method" {
  type    = string
  default = "DNS"
}

variable "tags" {
  type = map(string)
}