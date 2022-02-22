variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "cpu" {
  description = "The number of cpu units reserved for the container. This field is optional for tasks using the Fargate launch type, and the only requirement is that the total amount of CPU reserved for all containers within a task be lower than the task-level cpu value."
  type        = number
  default     = null
}

variable "memory" {
  description = "The amount (in MiB) of memory to present to the container. If your container attempts to exceed the memory specified here, the container is killed."
  type        = number
  default     = null
}

variable "memory_reservation" {
  description = "The soft limit (in MiB) of memory to reserve for the container. When system memory is under heavy contention, Docker attempts to keep the container memory to this soft limit. However, your container can consume more memory when it needs to, up to either the hard limit specified with the memory parameter (if applicable), or all of the available memory on the container instance, whichever comes first."
  type        = number
  default     = null
}

variable "essential" {
  description = "When true, and container fails or stops for any reason, all other containers that are part of the task are stopped."
  type        = bool
  default     = true
}

variable "privileged" {
  description = "When true, the container is given elevated privileges on the host container instance (similar to the root user)."
  type        = bool
  default     = false
}

variable "interactive" {
  description = "When true, you can deploy containerized applications that require stdin or a tty to be allocated-."
  type        = bool
  default     = false
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

variable "port_mappings" {
  description = "Allow containers to access ports on the host container instance to send or receive traffic."
  type = list(object({
    protocol       = string
    host_port      = number
    container_port = number
  }))
}


variable "environment_variables" {
  description = "The environment variables to pass to a container."
  type = list(object({
    name  = string
    value = string
  }))
}

variable "secrets" {
  description = "The secrets to pass to the container."
  type = list(object({
    name = string
    arn  = string
  }))
  default = []
}

variable "ulimits" {
  type = list(object({
    name       = string
    soft_limit = number
    hard_limit = number
  }))
  default = []
}

variable "mount_points" {
  description = "The mount points for data volumes in your container."
  type = list(object({
    source_volume  = string
    container_path = string
    read_only      = bool
  }))
  default = []
}

variable "volumes_from" {
  description = "Data volumes to mount from another container."
  type = list(object({
    source_container = string
    read_only        = bool
  }))
  default = []
}