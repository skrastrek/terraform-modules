data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowObjectLambdaAccess"
    effect = "Allow"
    actions = [
      "s3-object-lambda:GetObject",
    ]
    resources = [var.s3_object_lambda_access_point_arn]
  }

  statement {
    sid    = "AllowLambdaInvocation"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [var.lambda_function_arn]
  }

  statement {
    sid    = "AllowStandardAccessPointAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = [var.s3_access_point_arn]
  }
}
