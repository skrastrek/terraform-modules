resource "aws_secretsmanager_secret" "config" {
  name = "${var.name}/config"

  recovery_window_in_days = 7

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "config" {
  secret_id = aws_secretsmanager_secret.config.id

  secret_string = jsonencode({
    region            = var.cognito_user_pool_region_id
    userPoolId        = var.cognito_user_pool_id
    userPoolDomain    = var.cognito_user_pool_domain
    userPoolAppId     = var.cognito_user_pool_client_id
    userPoolAppSecret = var.cognito_user_pool_client_secret
    parseAuthPath     = var.callback_path
    cookieDomain      = var.cookie_domain
    cookiePath        = var.cookie_path
    sameSite          = var.cookie_same_site
    httpOnly          = var.cookie_http_only
    logoutConfiguration = {
      logoutUri         = var.logout_uri
      logoutRedirectUri = var.logout_redirect_uri
    }
  })
}
