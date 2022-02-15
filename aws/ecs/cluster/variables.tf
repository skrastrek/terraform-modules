variable "cluster_name" {
  type = string
}

variable "container_insights_enabled" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

variable "tags" {
  type = map(string)
}