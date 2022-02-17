variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = set(string)
}

variable "inbound_cidr_blocks" {
  type = list(string)
}

variable "outbound_cidr_blocks" {
  type = list(string)
}

variable "certificate_arn" {
  description = "ARN of the default SSL server certificate."
  type        = string
}

variable "additional_certificate_arns" {
  type = set(string)
}

variable "internal" {
  type    = bool
  default = false
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "idle_timeout_in_seconds" {
  type    = number
  default = 30
}

variable "enable_http2" {
  type    = bool
  default = true
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type = map(string)
}