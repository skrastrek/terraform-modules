variable "name" {
  type = string
}

variable "keep_last_images_count" {
  type = number
}

variable "image_tag_mutability" {
  type = string
}

variable "scan_on_push" {
  type = bool
}

variable "resource_policy_pull_image_from_account_ids" {
  type = list(string)
}

variable "resource_policy_pull_image_from_organization_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
