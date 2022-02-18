resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  desired_count                      = var.service_desired_count
  launch_type                        = var.launch_type
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  propagate_tags                     = var.service_propagate_tags

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = concat([aws_security_group.ecs_service.id], var.service_security_group_ids)
    assign_public_ip = var.service_assign_public_ip
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  dynamic "load_balancer" {
    for_each = var.lb_arn == null ? [] : [1]
    content {
      container_name   = var.container_name
      container_port   = var.container_port
      target_group_arn = aws_lb_target_group.ecs_service.arn
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registries

    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }

  tags = var.tags
}