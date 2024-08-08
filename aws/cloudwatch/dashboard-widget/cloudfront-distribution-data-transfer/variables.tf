variable "cloudfront_distribution_id" {
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

variable "label_color_bytes_downloaded" {
  type    = string
  default = "#1f77b4"
}

variable "label_color_bytes_uploaded" {
  type    = string
  default = "#ff7f0e"
}
