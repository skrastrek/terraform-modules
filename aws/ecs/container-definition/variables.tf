variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "essential" {
  type    = bool
  default = true
}

variable "repository_credential_arn" {
  type    = string
  default = null
}

variable "command" {
  description = "The command that is passed to the container."
  type        = string
  default     = null
}

variable "stop_timeout_in_seconds" {
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own. On Fargate the maximum value is 120 seconds."
  type        = number
  default     = null
}

variable "log_group_name" {
  type = string
}

variable "log_region_name" {
  type = string
}

variable "secrets" {
  type = list(object({
    name = string
    arn  = string
  }))
}

variable "port_mappings" {
  type = list(object({
    host_port      = number
    container_port = number
    protocol       = string
  }))
}

variable "environment_variables" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "mount_points" {
  type = list(object({
    source_volume  = string
    container_path = string
    read_only      = bool
  }))
}