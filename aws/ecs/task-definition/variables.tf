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

variable "role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "container_definitions" {
  description = "JSON array of container definitions."
  type        = string
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

variable "tags" {
  type = map(string)
}