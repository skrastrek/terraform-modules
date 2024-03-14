variable "allow_root_account_id" {
  type    = string
  default = null
}

variable "allow_service_principals" {
  type    = list(string)
  default = []
}