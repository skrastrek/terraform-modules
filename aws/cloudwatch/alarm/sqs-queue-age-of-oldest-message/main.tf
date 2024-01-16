resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.sqs_queue_name}-sqs-queue-age-of-oldest-message"
  alarm_description = var.alarm_description

  namespace   = "AWS/SQS"
  metric_name = "ApproximateAgeOfOldestMessage"
  statistic   = "Maximum"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    QueueName = var.sqs_queue_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
