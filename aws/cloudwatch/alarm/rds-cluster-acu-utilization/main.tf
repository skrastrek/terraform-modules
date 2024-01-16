resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.db_cluster_name}-rds-cluster-acu-utilization"
  alarm_description = var.alarm_description

  namespace   = "AWS/RDS"
  metric_name = "ACUUtilization"
  statistic   = "Average"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold * 100

  dimensions = {
    DBClusterIdentifier = var.db_cluster_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
