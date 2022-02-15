variable "name" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "task_definition_arn" {
  type = string
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "network_configuration" {
  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })
}

variable "load_balancers" {
  type = map(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  default = {}
}

variable "service_registries" {
  type = map(object({
    registry_arn   = string
    port           = number
    container_port = number
    container_name = string
  }))
  default = {}
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "deployment_maximum_percent" {
  type    = number
  default = 200
}

variable "deployment_controller_type" {
  type    = string
  default = "ECS"
}

variable "propagate_tags" {
  type    = string
  default = "SERVICE"
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = null
}

variable "tags" {
  type = map(string)
}