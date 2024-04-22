variable "table_name" {
  type = string
}

variable "read_capacity_min" {
  type = number
}

variable "read_capacity_max" {
  type = number
}

variable "read_capacity_utilization_target" {
  type    = number
  default = 75
}

variable "read_capacity_scale_in_cooldown" {
  type    = number
  default = 0
}

variable "read_capacity_scale_out_cooldown" {
  type    = number
  default = 0
}

variable "write_capacity_min" {
  type = number
}

variable "write_capacity_max" {
  type = number
}

variable "write_capacity_utilization_target" {
  type    = number
  default = 75
}

variable "write_capacity_scale_in_cooldown" {
  type    = number
  default = 0
}

variable "write_capacity_scale_out_cooldown" {
  type    = number
  default = 0
}
