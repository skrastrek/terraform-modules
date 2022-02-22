variable "vpc_id" {
  type = string
}

variable "vpc_subnets" {
  description = "Subnet ids inside the VPC where the service should be placed."
  type        = list(string)
}

variable "cluster_arn" {
  type = string
}

variable "load_balancers" {
  type = map(object({
    arn            = string
    container_name = string
    container_port = number
  }))
}

variable "name" {
  type = string
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

variable "assign_public_ip" {
  type = bool
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "container_definitions" {
  description = "JSON array of container definitions."
  type        = string
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "propagate_tags" {
  type    = string
  default = "SERVICE"
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "task_desired_count" {
  type = number
}

variable "task_port" {
  description = "Port to use for routing traffic to the service task."
  type        = number
}

variable "task_protocol" {
  description = "Protocol to use for routing traffic to the service task."
  type        = string
  default     = "HTTP"
}

variable "task_protocol_version" {
  type    = string
  default = "HTTP1"
}

variable "task_health_check" {
  description = "A health block containing health check settings for the service task."
  type = object({
    enabled             = bool
    protocol            = string
    port                = string
    path                = string
    matcher             = string
    timeout             = number
    interval            = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })

  default = {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-299"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = null
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

variable "tags" {
  type = map(string)
}