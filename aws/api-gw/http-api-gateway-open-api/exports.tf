resource "local_file" "openapi_specification" {
  count = var.openapi_specification_export_enabled ? 1 : 0

  content  = aws_apigatewayv2_api.this.body
  filename = "${var.openapi_specification_export_file_path}/${var.openapi_specification_export_file_name}"
}
