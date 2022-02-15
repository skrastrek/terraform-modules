resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = var.role_arn
  execution_role_arn       = var.execution_role_arn

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
    }
  }

  container_definitions = <<EOF
[{
    "name": "${var.container_name}",
    "image": "${var.container_image}",
    %{if var.container_repository_credentials != null~}
    "repositoryCredentials": {
        "credentialsParameter": "${var.container_repository_credentials}"
    },
    %{~endif}
    %{if length(var.container_secrets) > 0~}
    "secrets": ${jsonencode(var.container_secrets)},
    %{~endif}
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "portMappings": ${jsonencode(var.port_mappings)},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.log_group_name}",
            "awslogs-region": "${var.log_region_name}",
            "awslogs-stream-prefix": "container"
        }
    },
    "mountPoints": ${jsonencode(var.container_mount_points)},
    "stopTimeout": ${var.container_stop_timeout_in_seconds},
    "command": ${jsonencode(var.container_command)},
    "environment": ${jsonencode(var.container_environment)}
}]
EOF

  tags = var.tags
}