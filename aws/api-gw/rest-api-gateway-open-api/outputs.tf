output "id" {
  value = aws_api_gateway_rest_api.this.id
}

output "arn" {
  value = aws_api_gateway_rest_api.this.arn
}

output "name" {
  value = aws_api_gateway_rest_api.this.name
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.this.execution_arn
}

output "body" {
  value = aws_api_gateway_rest_api.this.body
}

output "stage_name" {
  value = aws_api_gateway_stage.this.stage_name
}

output "access_log_group_name" {
  value = aws_cloudwatch_log_group.access_logs.name
}

output "execution_log_group_name" {
  value = aws_cloudwatch_log_group.execution_logs.name
}

output "invoke_url" {
  value = aws_api_gateway_stage.this.invoke_url
}
