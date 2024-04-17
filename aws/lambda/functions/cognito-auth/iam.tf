resource "aws_iam_role" "this" {
  name               = var.function_name
  assume_role_policy = module.assume_role_policy_document.json
}

module "assume_role_policy_document" {
  source = "../../../iam/policy-documents/service-assume-role"

  service_identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
}

module "cloudwatch_write_logs_role_policy" {
  source = "../../../iam/role-policies/cloudwatch-write-logs"

  role_name = aws_iam_role.this.name

  log_group_arns = [aws_cloudwatch_log_group.this.arn]
}
