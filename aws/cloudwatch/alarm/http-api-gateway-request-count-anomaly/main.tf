resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.api_gateway_name}-api-gateway-request-count-anomaly"
  alarm_description = var.alarm_description

  metric_query {
    id          = "api_gw_request_count_anomaly_detection_band"
    return_data = true
    label       = "Anomaly Detection Threshold"
    expression  = "ANOMALY_DETECTION_BAND(request_count_sum,${var.threshold})"
  }

  metric_query {
    id          = "request_count_sum"
    return_data = true
    label       = "Request count"

    metric {
      namespace   = "AWS/ApiGateway"
      metric_name = "Count"
      stat        = "Sum"
      period      = var.period

      dimensions = {
        ApiName  = var.api_gateway_name
        Method   = var.api_gateway_method
        Resource = var.api_gateway_resource
        Stage    = var.api_gateway_stage_name
      }
    }
  }

  threshold_metric_id = "api_gw_request_count_anomaly_detection_band"
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
