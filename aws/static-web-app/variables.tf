variable "name_prefix" {
  type    = string
}

variable "acm_certificate_arn_us_east_1" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "domain_name_zone_id" {
  type = string
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "spa_redirect_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type = map(string)
}
