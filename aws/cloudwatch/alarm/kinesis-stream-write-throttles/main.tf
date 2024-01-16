resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.kinesis_stream_name}-kinesis-stream-write-throttles"
  alarm_description = var.alarm_description

  namespace   = "AWS/Kinesis"
  metric_name = "WriteProvisionedThroughputExceeded"

  statistic = "Average"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    StreamName = var.kinesis_stream_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}