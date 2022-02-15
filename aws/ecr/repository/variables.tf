variable "name" {
  type = string
}

variable "keep_last_images_count" {
  type = number
}

variable "image_tag_mutability" {
  type = string
}

variable "allow_pull_from_aws_account_ids" {
  type = list(string)
}

variable "push_image_iam_policy_name" {
  type = string
}

variable "tags" {
  type = map(string)
}