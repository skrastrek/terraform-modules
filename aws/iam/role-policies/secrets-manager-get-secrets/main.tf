resource "aws_iam_role_policy" "this" {
  role   = var.role_id
  name   = "SecretsManagerGetSecrets"
  policy = data.aws_iam_policy_document.secrets_manager_get_secrets.json
}

data "aws_iam_policy_document" "secrets_manager_get_secrets" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = var.secret_arns
  }
}