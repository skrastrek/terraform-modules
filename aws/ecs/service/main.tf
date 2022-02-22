resource "aws_ecs_service" "this" {
  name                               = var.name
  cluster                            = var.cluster_arn
  desired_count                      = var.task_desired_count
  task_definition                    = module.ecs_task_definition.arn
  launch_type                        = var.launch_type
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  propagate_tags                     = var.propagate_tags

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = concat([aws_security_group.this.id], var.security_group_ids)
    assign_public_ip = var.assign_public_ip
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      container_name   = var.task_container_name
      container_port   = var.task_container_port
      target_group_arn = aws_lb_target_group.this[load_balancer.key].arn
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

module "ecs_task_definition" {
  source = "../task-definition"

  family = var.name

  cpu    = var.task_cpu
  memory = var.task_memory

  role_arn           = module.ecs_task_role.arn
  execution_role_arn = module.ecs_task_execution_role.arn

  container_definitions = var.container_definitions

  tags = var.tags
}

module "ecs_task_role" {
  source = "../../iam/roles/ecs-task"

  name = "${var.name}-task"

  tags = var.tags
}

module "ecs_task_execution_role" {
  source = "../../iam/roles/ecs-task-execution"

  name = "${var.name}-task-execution"

  tags = var.tags
}