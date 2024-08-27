resource "aws_iam_role_policy" "this" {
  role   = var.role_name
  name   = var.policy_name
  policy = module.policy_document.json
}

module "policy_document" {
  source = "../../policy-documents/sqs-queue-consume"

  sqs_queue_arn         = var.sqs_queue_arn
  sqs_queue_kms_key_arn = var.sqs_queue_kms_key_arn
}
