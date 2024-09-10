resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = module.assume_role_policy_document.json

  tags = var.tags
}

module "assume_role_policy_document" {
  source = "../../iam/policy-documents/service-assume-role"

  service_identifiers = ["lambda.amazonaws.com"]
}

resource "aws_iam_role_policy_attachment" "amazon_s3_object_lambda_execution_role_policy" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ObjectLambdaExecutionRolePolicy"
}
