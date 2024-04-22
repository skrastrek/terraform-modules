data "aws_region" "current" {}

locals {
  node_project_path = "${path.module}/resources/nodejs"

}

data "external" "npm_build" {
  program = [
    "bash", "-c", <<EOT
(npm ci && npm run build) >&2 && echo "{\"filename\": \"index.js\"}"
EOT
  ]
  working_dir = local.node_project_path
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${local.node_project_path}/dist/${data.external.npm_build.result.filename}"
  output_path = "${local.node_project_path}/dist/lambda.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  role          = aws_iam_role.this.arn

  publish = true

  runtime     = "nodejs20.x"
  memory_size = var.memory_size

  handler = "index.handler"

  package_type     = title(data.archive_file.zip.type)
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  logging_config {
    log_format            = "JSON"
    application_log_level = "INFO"
    system_log_level      = "DEBUG"
  }

  environment {
    variables = {
      JWT_AUDIENCE            = var.jwt_audience
      JWT_ISSUER              = var.jwt_issuer
      JWT_SCOPE               = var.jwt_scope
      JWT_SOURCE_HEADER_NAME  = var.jwt_source_header_name
      JWT_SOURCE_COOKIE_REGEX = var.jwt_source_cookie_regex
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}
