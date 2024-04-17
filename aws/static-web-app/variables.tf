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

variable "spa_redirect_enabled" {
  type = bool
}

variable "api_gateway_origins" {
  type = list(object({
    origin_id   = string
    domain_name = string
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
