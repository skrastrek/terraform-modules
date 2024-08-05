data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowObjectLambdaAccess"
    effect = "Allow"
    actions = [
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
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

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["s3-object-lambda.amazonaws.com"]
    }
  }

  statement {
    sid    = "AllowStandardAccessPointAccess"
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = ["${var.s3_access_point_arn}/*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:CalledVia"
      values   = ["s3-object-lambda.amazonaws.com"]
    }
  }
}
