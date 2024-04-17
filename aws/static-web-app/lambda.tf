module "cognito_auth_lambda" {
  source = "../lambda/functions/cognito-auth"

  function_name                     = ""
  cloudwatch_logs_retention_in_days = 0
  cognito_user_pool_arn             = ""
  cognito_user_pool_client_id       = ""
  cognito_user_pool_domain          = ""
  memory_size                       = 0

  tags = var.tags
}