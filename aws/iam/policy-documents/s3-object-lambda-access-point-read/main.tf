data "aws_iam_policy_document" "this" {
  statement {
    sid    = "GetObject"
    effect = "Allow"
    actions = [
      "s3-object-lambda:GetObject",
    ]
    resources = [var.s3_object_lambda_access_point_arn]
  }
  statement {
    sid    = "InvokeFunction"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [var.lambda_function_arn]
  }
}
