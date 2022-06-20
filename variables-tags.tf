variable "default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "app_gateway_tags" {
  description = "Application Gateway tags."
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to add."
  type        = map(string)
  default     = {}
}

variable "ip_tags" {
  description = "Public IP tags."
  type        = map(string)
  default     = {}
}

variable "nsg_tags" {
  description = "Network Security Group tags."
  type        = map(string)
  default     = {}
}
