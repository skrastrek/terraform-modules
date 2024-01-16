resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.kinesis_stream_name}-kinesis-stream-write-count-anomaly"
  alarm_description = var.alarm_description

  metric_query {
    id          = "incoming_records_sum_anomaly_detection_band"
    return_data = true
    label       = "Anomaly Detection Threshold"
    expression  = "ANOMALY_DETECTION_BAND(incoming_records_sum,5)"
  }

  metric_query {
    id          = "incoming_records_sum"
    return_data = true
    label       = "Writes"
    metric {
      namespace   = "AWS/Kinesis"
      metric_name = "IncomingRecords"
      period      = var.period
      stat        = "Sum"

      dimensions = {
        StreamName = var.kinesis_stream_name
      }
    }
  }

  threshold_metric_id = "incoming_records_sum_anomaly_detection_band"
  comparison_operator = "LessThanLowerOrGreaterThanUpperThreshold"
  evaluation_periods  = var.evaluation_periods

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
