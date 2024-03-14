data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.allow_verify_network_resources ? [1] : []
    content {
      sid    = "VerifyNetworkResources"
      effect = "Allow"

      actions = [
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups"
      ]
      resources = ["*"]
    }
  }
}
