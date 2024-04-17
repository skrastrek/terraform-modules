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

variable "spa_error_responses" {
  type = list(object({
    error_code = number
    page_path  = string
  }))
}

variable "api_gateway_origins" {
  type = list(object({
    origin_id   = string
    domain_name = string
  }))
  default = []
}

variable "auth_enabled" {
  type = bool
}

variable "auth_function_arn" {
  type = string
}

variable "auth_routes" {
  type = list(object({
    path_pattern = string
    function_arn = string
  }))
  default = []
}

variable "ordered_cache_behaviours" {
  type = list(object({
    target_origin_id = string
    path_pattern     = string

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
