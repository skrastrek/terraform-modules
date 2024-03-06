output "url" {
  value = aws_ecr_repository.this.repository_url
}

output "push_image_iam_policy_arn" {
  value = aws_iam_policy.push_image.arn
}
