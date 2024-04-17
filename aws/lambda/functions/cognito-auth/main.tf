data "aws_arn" "cognito_user_pool" {
  arn = var.cognito_user_pool_arn
}

locals {
  node_directory_path = "${path.module}/resources/function"
}

resource "local_file" "index" {
  filename = "${local.node_directory_path}/src/index.js"

  content = templatefile("${path.module}/resources/index-template.js", {
    cognito_user_pool_region_id = data.aws_arn.cognito_user_pool.region
    cognito_user_pool_id        = data.aws_arn.cognito_user_pool.id
    cognito_user_pool_client_id = var.cognito_user_pool_client_id
    cognito_user_pool_domain    = var.cognito_user_pool_domain
  })
}

resource "terraform_data" "npm_ci" {
  triggers_replace = {
    index        = local_file.index.content_sha256
    package      = sha256(file("${local.node_directory_path}/package.json"))
    package_lock = sha256(file("${local.node_directory_path}/package-lock.json"))
    node_modules = sha1(join("", [
      for f in fileset("${local.node_directory_path}/node_modules", "**") :
      filesha1("${local.node_directory_path}/node_modules/${f}")
    ]))
  }

  provisioner "local-exec" {
    command = "cd ${local.node_directory_path} && npm ci"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = local.node_directory_path
  output_path = "lambda_function.zip"

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
}

resource "aws_lambda_permission" "invoke_from_cloudfront" {
  function_name = aws_lambda_function.this.function_name
  qualifier     = aws_lambda_function.this.version

  statement_id = "AllowExecutionFromCloudFront"
  action       = "lambda:InvokeFunction"
  principal    = "edgelambda.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}
