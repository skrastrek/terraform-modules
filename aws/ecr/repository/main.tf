resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.id
  policy = templatefile("resources/ecr-lifecycle-policy.tpl", {
    keep_last_images_count = var.keep_last_images_count
  })
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.id
  policy     = data.aws_iam_policy_document.allow_pull_image_cross_account.json
}

data "aws_iam_policy_document" "allow_pull_image_cross_account" {
  statement {
    sid    = "AllowPullImageCrossAccount"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.allow_pull_from_aws_account_ids)
    }
  }
}

resource "aws_iam_policy" "push_image" {
  name        = var.push_image_iam_policy_name
  description = "Provides access to push images to ${aws_ecr_repository.this.name} container repository."
  policy      = data.aws_iam_policy_document.allow_push_image.json
  tags        = var.tags
}

data "aws_iam_policy_document" "allow_push_image" {
  statement {
    sid    = "AllowPushImage"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      aws_ecr_repository.this.arn
    ]
  }
}
