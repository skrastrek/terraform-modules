resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.source_s3_bucket_name}-s3-bucket-replication-failures"
  alarm_description = var.alarm_description

  namespace   = "AWS/S3"
  metric_name = "OperationsFailedReplication"
  statistic   = "Sum"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    SourceBucket      = var.source_s3_bucket_name
    DestinationBucket = var.destination_s3_bucket_name
    RuleId            = var.source_s3_bucket_replication_rule_id
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
