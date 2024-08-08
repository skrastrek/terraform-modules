variable "api_gateway_name" {
  type        = string
}

variable "api_gateway_stage" {
  type        = string
}

variable "title" {
  type        = string
}

variable "period" {
  type        = number
}

variable "display_live_data" {
  description = "Live data is data published within the last minute that has not been fully aggregated."
  type        = bool
  default     = false
}

variable "width" {
  type        = number
  default     = 12
}

variable "height" {
  type        = number
  default     = 6
}

variable "position_x" {
  type        = number
}

variable "position_y" {
  type        = number
}

variable "label_color_p10" {
  type        = string
  default     = "#d62728"
}

variable "label_color_p50" {
  type        = string
  default     = "#ff7f0e"
}

variable "label_color_p90" {
  type        = string
  default     = "#1f77b4"
}