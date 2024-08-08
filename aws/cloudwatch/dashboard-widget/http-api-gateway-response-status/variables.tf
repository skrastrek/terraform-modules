variable "api_gateway_id" {
  type = string
}

variable "api_gateway_stage" {
  type = string
}

variable "title" {
  type = string
}

variable "period" {
  type = number
}

variable "display_live_data" {
  description = "Live data is data published within the last minute that has not been fully aggregated."
  type        = bool
  default     = false
}

variable "width" {
  type = number
}

variable "height" {
  type = number
}

variable "position_x" {
  type = number
}

variable "position_y" {
  type = number
}

variable "label_color_5xx" {
  type    = string
  default = "#d62728"
}

variable "label_color_4xx" {
  type    = string
  default = "#ff7f0e"
}

variable "label_color_2xx" {
  type    = string
  default = "#2ca02c"
}

variable "label_color_request" {
  type    = string
  default = "#1f77b4"
}