locals {
  definition = {
    name = var.name

    image = var.image

    cpu               = var.cpu
    memory            = var.memory
    memoryReservation = var.memory_reservation

    essential   = var.essential
    privileged  = var.privileged
    interactive = var.interactive

    command     = var.command
    stopTimeout = var.stop_timeout_in_seconds

    repositoryCredentials = var.repository_credential_arn != null ? {
      credentialsParameter = var.repository_credential_arn
    } : null

    secrets = [
      for secret in var.secrets : {
        name      = secret.name
        valueFrom = secret.arn
      }
    ]

    environment = [
      for environment_variable in var.environment_variables : {
        name  = environment_variable.name
        value = environment_variable.value
      }
    ]

    ulimits = [
      for ulimit in var.ulimits : {
        name      = ulimit.name
        softLimit = ulimit.soft_limit
        hardLimit = ulimit.hard_limit
      }
    ]

    mountPoints = [
      for mount_point in var.mount_points : {
        sourceVolume  = mount_point.source_volume
        containerPath = mount_point.container_path
        readOnly      = mount_point.read_only
      }
    ]

    volumesFrom = [
      for volume in var.volumes_from : {
        sourceContainer = volume.source_container
        readOnly        = volume.read_only
      }
    ]

    portMappings = [
      for port_mapping in var.port_mappings : {
        hostPort      = port_mapping.host_port
        containerPort = port_mapping.container_port
        protocol      = port_mapping.protocol
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.log_group_name
        awslogs-region        = var.log_region_name
        awslogs-stream-prefix = "container"
      }
    }
  }
}