data "aws_iam_policy" "cloudwatch_access" {
  name = "AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_region" "current" {}

module "gateway_cloudwatch_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 5.0"

  trusted_role_services             = ["apigateway.amazonaws.com"]
  create_role                       = true
  role_name                         = "api-gateway-cloudwatch-logs-${data.aws_region.current.name}"
  role_description                  = "Enable logs from API Gateway."
  role_permissions_boundary_arn     = var.permission_boundary_arn
  role_requires_mfa                 = false
  number_of_custom_role_policy_arns = 1

  custom_role_policy_arns = [
    data.aws_iam_policy.cloudwatch_access.arn
  ]

  tags = var.tags
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = module.gateway_cloudwatch_role.iam_role_arn
}
