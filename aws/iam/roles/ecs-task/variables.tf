variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "log_group_arn" {
  type = string
}