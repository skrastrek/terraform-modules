resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.lambda_function_name}-lambda-function-duration"
  alarm_description = var.alarm_description

  namespace          = "AWS/Lambda"
  metric_name        = "Duration"
  extended_statistic = "p95"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}