resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name        = var.alarm_name != null ? var.alarm_name : "${var.dynamodb_table_name}-dynamodb-table-system-read-errors"
  alarm_description = var.alarm_description

  namespace   = "AWS/DynamoDB"
  metric_name = "SystemReadErrors"
  statistic   = "Average"

  period             = var.period
  evaluation_periods = var.evaluation_periods

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.threshold

  dimensions = {
    TableName = var.dynamodb_table_name
    Operation = "GetItem,Query,Scan,BatchGetItem,TransactGetItems,GetRecords"
  }

  treat_missing_data = var.treat_missing_data

  ok_actions                = var.ok_actions
  alarm_actions             = var.alarm_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = var.tags
}
