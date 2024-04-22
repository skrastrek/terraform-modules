locals {
  resource_id = "table/${var.table_name}/index/${var.global_secondary_index_name}"
}

resource "aws_appautoscaling_target" "read_capacity" {
  resource_id = local.resource_id

  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:index:ReadCapacityUnits"

  min_capacity = var.read_capacity_min
  max_capacity = var.read_capacity_max
}

resource "aws_appautoscaling_policy" "read_capacity" {
  name = "${var.table_name}-dynamodb-${var.global_secondary_index_name}-gsi-read-capacity"

  resource_id        = aws_appautoscaling_target.read_capacity.resource_id
  scalable_dimension = aws_appautoscaling_target.read_capacity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_capacity.service_namespace

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = var.read_capacity_utilization_target
    scale_in_cooldown  = var.read_capacity_scale_in_cooldown
    scale_out_cooldown = var.read_capacity_scale_out_cooldown
  }
}

resource "aws_appautoscaling_target" "write_capacity" {
  resource_id = local.resource_id

  service_namespace  = "dynamodb"
  scalable_dimension = "dynamodb:index:WriteCapacityUnits"

  min_capacity = var.write_capacity_min
  max_capacity = var.write_capacity_max
}

resource "aws_appautoscaling_policy" "write_capacity" {
  name = "${var.table_name}-dynamodb-${var.global_secondary_index_name}-gsi-write-capacity"

  resource_id        = aws_appautoscaling_target.write_capacity.resource_id
  scalable_dimension = aws_appautoscaling_target.write_capacity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_capacity.service_namespace

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = var.write_capacity_utilization_target
    scale_in_cooldown  = var.write_capacity_scale_in_cooldown
    scale_out_cooldown = var.write_capacity_scale_out_cooldown
  }
}
