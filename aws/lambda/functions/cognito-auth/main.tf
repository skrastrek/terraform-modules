data "aws_arn" "cognito_user_pool" {
  arn = var.cognito_user_pool_arn
}

locals {
  node_project_directory_path = "${path.module}/resources/function"
}

resource "local_file" "function" {
  filename = "${local.node_project_directory_path}/src/index.js"
  content  = templatefile("${path.module}/resources/index-template.js", {
    cognito_user_pool_region_id = data.aws_arn.cognito_user_pool.region
    cognito_user_pool_id        = data.aws_arn.cognito_user_pool.id
    cognito_user_pool_client_id = var.cognito_user_pool_client_id
    cognito_user_pool_domain    = var.cognito_user_pool_domain
  })
}

data "external" "npm_install" {
  program     = ["bash", "-c", "npm install"]
  working_dir = local.node_project_directory_path
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = local.node_project_directory_path
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.this.arn

  publish = true

  runtime     = "nodejs20.x"
  memory_size = var.memory_size

  handler = "index.handler"

  package_type     = "Zip"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha512
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/us-east-1.${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}