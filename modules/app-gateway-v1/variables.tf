# Common inputs

variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "enable_http2" {
  description = "Enable HTTP2"
  type        = bool
  default     = true
}

# Network inputs

variable "custom_ippub_name" {
  description = "Name of the Public IP, generated if not set."
  type        = string
  default     = ""
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  type        = string
  default     = ""
}

variable "ip_sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  type        = string
  default     = "Basic"
}

variable "ip_allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
  default     = "Dynamic"
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network where we'll create the Application Gateway dedicated subnet"
  type        = string
}

variable "subnet_cidr_list" {
  description = "List of CIDRs to create Application Gateway dedicated subnet"
  type        = list(string)
}

variable "custom_security_group_name" {
  description = "Custom Network Security Group name, generated if not set"
  type        = string
  default     = ""
}

# Application gateway inputs

variable "custom_appgw_name" {
  description = "Name of the Application Gateway, generated if not set."
  type        = string
  default     = ""
}

variable "sku" {
  description = "Map to define the sku of the Application Gateway: Standard(Small, Medium, Large) or WAF (Medium, Large), and the capacity (between 1 and 10)"
  type        = map(string)
}

variable "frontend_port" {
  description = "A list of ports used for the Frontend Port. Can be empty"
  type        = list(number)
  default     = []
}

variable "waf_configuration_settings" {
  description = "A map used to configured WAF if defined"
  type        = map(string)
  default     = {}
}

variable "disabled_rule_group_settings" {
  type = list(object({
    rule_group_name = string
    rules           = list(string)
  }))
  description = "List of objects including rule groups to disable"
  default     = []
}

variable "ssl_policy" {
  description = "A map used to configured SSL policy if defined"
  type        = map(string)
  default     = {}
}

variable "appgw_http_listeners" {
  type        = list(map(string))
  description = "List of maps including http listeners configurations"
}

variable "appgw_backend_pools" {
  type = list(object({
    name  = string
    fqdns = list(string)
  }))
  description = "List of objects including backend pool configurations"
}

variable "appgw_backend_http_settings" {
  type        = list(map(string))
  description = "List of maps including backend http settings configurations"
}

variable "authentication_certificate_configs" {
  type        = list(map(string))
  description = "List of maps including authentication certificate configurations"
}

variable "ssl_certificates_configs" {
  type        = list(map(string))
  description = "List of maps including ssl certificates configurations"
}

variable "appgw_routings" {
  type        = list(map(string))
  description = "List of maps including request routing rules configurations"
}

variable "appgw_probes" {
  type        = list(map(string))
  description = "List of maps including request probes configurations"
}

variable "appgw_url_path_map" {
  type = list(object({
    name                               = string
    default_backend_address_pool_name  = string
    default_backend_http_settings_name = string
    path_rule = list(object({
      name                       = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      paths                      = list(string)
    }))
  }))
  description = "List of maps including url path map configurations"
  default     = []
}

variable "appgw_redirect_configuration" {
  type        = list(map(string))
  description = "List of maps including redirect configurations"
  default     = []
}
