data "aws_region" "current" {}

locals {
  resource_path     = "${path.module}/resources"
  node_project_path = "${local.resource_path}/nodejs"
}

resource "local_file" "index" {
  filename = "${local.node_project_path}/index.mjs"

  content = templatefile("${local.resource_path}/index-template.mjs", {
    cognito_user_pool_id            = var.cognito_user_pool_id
    cognito_user_pool_region_id     = var.cognito_user_pool_region_id
    cognito_user_pool_domain        = var.cognito_user_pool_domain
    cognito_user_pool_client_id     = var.cognito_user_pool_client_id
    cognito_user_pool_client_secret = var.cognito_user_pool_client_secret

    cookie_domain    = var.cookie_domain
    cookie_path      = var.cookie_path
    cookie_http_only = var.cookie_http_only
    cookie_same_site = var.cookie_same_site

    callback_path        = var.callback_path
    logout_path          = var.logout_path
    logout_redirect_path = var.logout_redirect_path
  })
}

resource "terraform_data" "npm_ci" {
  triggers_replace = {
    index        = local_file.index.content_sha256
    package      = sha256(file("${local.node_project_path}/package.json"))
    package_lock = sha256(file("${local.node_project_path}/package-lock.json"))
    node_modules = sha1(join("", [
      for f in fileset("${local.node_project_path}/node_modules", "**") :
      filesha1("${local.node_project_path}/node_modules/${f}")
    ]))
  }

  provisioner "local-exec" {
    command = "cd ${local.node_project_path} && npm ci"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${local.node_project_path}/"
  output_path = "${local.resource_path}/cognito-auth.zip"

  depends_on = [terraform_data.npm_ci]
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
  source_code_hash = data.archive_file.lambda.output_base64sha256

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
  name              = "/aws/lambda/${data.aws_region.current.id}.${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}
