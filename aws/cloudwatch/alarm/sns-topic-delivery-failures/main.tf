resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.sns_topic_name}-sns-topic-delivery-failures"
  alarm_description = var.alarm_description

  namespace   = "AWS/SNS"
  metric_name = "NumberOfNotificationsFailed"
  statistic   = "Average"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    TopicName = var.sns_topic_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}