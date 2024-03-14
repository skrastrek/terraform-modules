variable "allow_verify_network_resources" {
  description = "Provides access to verify network resources, which are required in some situations. For instance, when creating Lambda event source mapping towards sources located within a VPC."
  type        = bool
  default     = false
}
