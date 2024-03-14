data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "rds-db:connect"
    ]
    resources = [
      "arn:aws:rds-db:${var.db_cluster_region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.db_cluster_resource_id}/${var.db_user}"
    ]
  }
}
