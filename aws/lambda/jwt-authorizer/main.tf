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

  handler = var.payload_format_version == "1.0" ? "index.handlerV1" : "index.handlerV2"

  package_type     = title(data.archive_file.zip.type)
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  logging_config {
    log_format            = var.logging_config.log_format
    application_log_level = var.logging_config.application_log_level
    system_log_level      = var.logging_config.system_log_level
  }

  environment {
    variables = {
      JWT_AUDIENCE            = var.jwt_audience != null ? join(",", var.jwt_audience) : null
      JWT_COGNITO_CLIENT_ID   = var.jwt_cognito_client_id != null ? join(",", var.jwt_cognito_client_id) : null
      JWT_COGNITO_GROUP       = var.jwt_cognito_group != null ? join(",", var.jwt_cognito_group) : null
      JWT_COGNITO_TOKEN_USE   = var.jwt_cognito_token_use
      JWT_ISSUER              = var.jwt_issuer
      JWT_SCOPE               = var.jwt_scope != null ? join(",", var.jwt_scope) : null
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
