data "aws_region" "current" {}

locals {
  node_project_path = "${path.module}/resources/nodejs"
}

resource "terraform_data" "npm_build" {
  triggers_replace = {
    index        = filebase64sha256("${local.node_project_path}/index.ts")
    package      = filebase64sha256("${local.node_project_path}/package.json")
    package_lock = filebase64sha256("${local.node_project_path}/package-lock.json")
  }

  provisioner "local-exec" {
    command = "cd ${local.node_project_path} && npm run build"
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${local.node_project_path}/dist/index.js"
  output_path = "${local.node_project_path}/dist/lambda.zip"

  depends_on = [terraform_data.npm_build]
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
}

resource "aws_lambda_permission" "invoke_from_cloudfront" {
  function_name = aws_lambda_function.this.function_name
  qualifier     = aws_lambda_function.this.version

  statement_id = "AllowExecutionFromCloudFront"
  action       = "lambda:InvokeFunction"
  principal    = "edgelambda.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${data.aws_region.current.id}.${var.name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}
