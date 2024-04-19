variable "name_prefix" {
  type = string
}

variable "acm_certificate_arn_us_east_1" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "domain_name_zone_id" {
  type = string
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "spa_enabled" {
  type        = bool
  description = "Enable or disable SPA-specific features."
}

variable "spa_custom_error_response_codes" {
  type = list(number)
}

variable "auth_enabled" {
  type = bool
}

variable "auth_default_cache_behaviour" {
  type = object({
    function_arn = string
  })
}

variable "auth_ordered_cache_behaviours" {
  type = list(object({
    path_pattern = string
    function_arn = string
  }))
  default = []
}

variable "s3_bucket_ordered_cache_behaviours" {
  type = list(object({
    path_pattern = string

    allowed_methods = list(string)
    cached_methods  = list(string)

    cache_policy_id            = string
    origin_request_policy_id   = string
    response_headers_policy_id = string

    compress = bool

    viewer_protocol_policy = string
  }))
  default = []
}

variable "tags" {
  type = map(string)
}
