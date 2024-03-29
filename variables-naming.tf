# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_caf_naming" {
  description = "Use the Azure CAF naming provider to generate default resource name. `custom_rg_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = true
}

# Custom naming override
variable "custom_appgw_name" {
  description = "Application Gateway custom name. Generated by default."
  type        = string
  default     = ""
}

variable "custom_ip_name" {
  description = "Public IP custom name. Generated by default."
  type        = string
  default     = ""
}

variable "custom_ip_label" {
  description = "Domain name label for public IP."
  type        = string
  default     = ""
}

variable "custom_frontend_ip_configuration_name" {
  description = "The custom name of the Frontend IP Configuration used. Generated by default."
  type        = string
  default     = ""
}

variable "custom_frontend_priv_ip_configuration_name" {
  description = "The Name of the private Frontend IP Configuration used for this HTTP Listener."
  type        = string
  default     = ""
}

variable "custom_gateway_ip_configuration_name" {
  description = "The Name of the Application Gateway IP Configuration."
  type        = string
  default     = ""
}

variable "custom_subnet_name" {
  description = "Custom name for the subnet."
  type        = string
  default     = ""
}

variable "custom_nsg_name" {
  description = "Custom name for the network security group."
  type        = string
  default     = null
}

variable "custom_nsr_https_name" {
  description = "Custom name for the network security rule for HTTPS protocol."
  type        = string
  default     = null
}

variable "custom_nsr_healthcheck_name" {
  description = "Custom name for the network security rule for internal health check of Application Gateway."
  type        = string
  default     = null
}
