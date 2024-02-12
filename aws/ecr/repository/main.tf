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

  policy = templatefile("resources/ecr-lifecycle-policy.tpl", {
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
  count = var.resource_policy_pull_image_from_aws_account_ids != null ? 1 : 0

  statement {
    sid     = "PullImageFromAwsAccount"
    effect  = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", var.resource_policy_pull_image_from_aws_account_ids)
    }
  }
}

data "aws_iam_policy_document" "allow_pull_image_from_organization" {
  count = var.resource_policy_pull_image_from_aws_organization_ids != null ? 1 : 0

  statement {
    sid     = "PullImageFromAwsOrganization"
    effect  = "Allow"
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
      values   = var.resource_policy_pull_image_from_aws_organization_ids
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
    sid     = "GetLoginPassword"
    effect  = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "PushImage"
    effect  = "Allow"
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
