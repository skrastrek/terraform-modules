variable "family" {
  type = string
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "network_mode" {
  type    = string
  default = "awsvpc"
}

variable "requires_compatibilities" {
  type = list(string)
  default = [
    "FARGATE"
  ]
}

variable "log_group_name" {
  type = string
}

variable "log_region_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "port_mappings" {
  description = "The service task's port mappings."
  type = list(object({
    hostPort      = number,
    containerPort = number,
    protocol      = string
  }))
}

variable "volumes" {
  description = "Volume blocks that containers in your task may use."
  type = list(object({
    host_path = string
    name      = string
    docker_volume_configuration = list(object({
      autoprovision = bool
      driver        = string
      driver_opts   = map(string)
      labels        = map(string)
      scope         = string
    }))
    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = string
      transit_encryption_port = number
      authorization_config = list(object({
        access_point_id = string
        iam             = string
      }))
    }))
  }))
  default = []
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_repository_credentials" {
  type    = string
  default = null
}

variable "container_command" {
  description = "The command that is passed to the container."
  type        = list(string)
  default     = []
}

variable "container_secrets" {
  description = "The secret variables to pass to a container."
  type = list(object({
    name      = string,
    valueFrom = string
  }))
  default = []
}

variable "container_environment" {
  description = "The environment variables to pass to a container."
  type = list(object({
    name  = string
    value = string
  }))
}

variable "container_mount_points" {
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = bool
  }))
  default = []
}

variable "container_stop_timeout_in_seconds" {
  description = "Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own. On Fargate the maximum value is 120 seconds."
  type        = number
  default     = 30
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
}