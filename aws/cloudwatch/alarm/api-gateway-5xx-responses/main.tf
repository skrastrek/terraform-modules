resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.api_gateway_name}-api-gateway-5xx-responses"
  alarm_description = var.alarm_description

  namespace   = "AWS/ApiGateway"
  metric_name = "5XXError"
  statistic   = "Average"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    ApiName  = var.api_gateway_name
    Method   = var.api_gateway_method
    Resource = var.api_gateway_resource
    Stage    = var.api_gateway_stage_name
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
