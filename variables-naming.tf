variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

variable "custom_name" {
  description = "Custom Application Gateway name, generated if not set."
  type        = string
  default     = ""
}

variable "public_ip_custom_name" {
  description = "Public IP custom name. Generated by default."
  type        = string
  default     = ""
}

variable "public_ip_label_custom_name" {
  description = "Domain name label for public IP."
  type        = string
  default     = ""
}

variable "frontend_ip_configuration_custom_name" {
  description = "The custom name of the Frontend IP Configuration used. Generated by default."
  type        = string
  default     = ""
}

variable "frontend_private_ip_configuration_custom_name" {
  description = "The Name of the private Frontend IP Configuration used for this HTTP Listener."
  type        = string
  default     = ""
}

variable "gateway_ip_configuration_custom_name" {
  description = "The Name of the Application Gateway IP Configuration."
  type        = string
  default     = ""
}

variable "subnet_custom_name" {
  description = "Custom name for the subnet."
  type        = string
  default     = ""
}

variable "nsg_custom_name" {
  description = "Custom name for the network security group."
  type        = string
  default     = null
}

variable "nsr_https_custom_name" {
  description = "Custom name for the network security rule for HTTPS protocol."
  type        = string
  default     = null
}

variable "nsr_healthcheck_custom_name" {
  description = "Custom name for the network security rule for internal health check of Application Gateway."
  type        = string
  default     = null
}
