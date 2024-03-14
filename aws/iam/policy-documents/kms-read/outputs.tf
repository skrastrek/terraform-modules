output "kms_key_read_policy" {
  value = data.aws_iam_policy_document.kms_read
}
