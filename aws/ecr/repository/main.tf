resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.id

  policy = templatefile("${path.module}/resources/ecr-lifecycle-policy.tpl", {
    keep_last_images_count = var.keep_last_images_count
  })
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.id
  policy     = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = compact([
    try(data.aws_iam_policy_document.allow_pull_image_from_aws_account[0].json, ""),
    try(data.aws_iam_policy_document.allow_pull_image_from_organization[0].json, ""),
  ])
}

data "aws_iam_policy_document" "allow_pull_image_from_aws_account" {
  count = length(var.resource_policy_pull_image_from_account_ids) != 0 ? 1 : 0

  statement {
    sid    = "PullImageFromAccount"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.resource_policy_pull_image_from_account_ids)
    }
  }
}

data "aws_iam_policy_document" "allow_pull_image_from_organization" {
  count = length(var.resource_policy_pull_image_from_organization_ids) != 0 ? 1 : 0

  statement {
    sid    = "PullImageFromOrganization"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalOrgID"
      values   = var.resource_policy_pull_image_from_organization_ids
    }
  }
}

resource "aws_iam_policy" "push_image" {
  name        = replace("${aws_ecr_repository.this.name}-ecr-repository-push-image", "/", "-")
  description = "Provides access to push images to ${aws_ecr_repository.this.name}."
  policy      = data.aws_iam_policy_document.allow_push_image.json

  tags = var.tags
}

data "aws_iam_policy_document" "allow_push_image" {
  statement {
    sid    = "GetLoginPassword"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "PushImage"
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
