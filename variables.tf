# COMMON

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
  default     = null
}

variable "app_gateway_tags" {
  description = "Application Gateway tags."
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

# PUBLIC IP

variable "ip_name" {
  description = "Public IP name."
  type        = string
  default     = ""
}

variable "ip_tags" {
  description = "Public IP tags."
  type        = map(string)
  default     = {}
}

variable "ip_label" {
  description = "Domain name label for public IP."
  type        = string
  default     = ""
}

### APPGW NETWORK

variable "app_gateway_subnet_id" {
  description = "Application Gateway subnet ID."
  type        = string
  default     = null
}

# Application gateway inputs

variable "appgw_name" {
  description = "Application Gateway name."
  type        = string
  default     = ""
}

variable "sku_capacity" {
  description = "The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale_configuration is set"
  type        = number
  default     = 2
}

variable "sku_name" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2."
  type        = string
  default     = "WAF_v2"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "frontend_ip_configuration_name" {
  description = "The Name of the Frontend IP Configuration used for this HTTP Listener."
  type        = string
  default     = ""
}

variable "gateway_ip_configuration_name" {
  description = "The Name of the Application Gateway IP Configuration."
  type        = string
  default     = ""
}

variable "frontend_port_settings" {
  description = "Frontend port settings. Each port setting contains the name and the port for the frontend port."
  type        = list(map(string))
  default     = []
}

variable "policy_name" {
  description = "Policy name to apply to the WAF configuration. The list of available policies can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview#predefined-ssl-policy"
  type        = string
  default     = "AppGwSslPolicy20170401S"
}

variable "authentication_certificate_configs" {
  description = "List of maps including authentication certificate configurations."
  type        = list(map(string))
  default     = []
}

variable "trusted_root_certificate_configs" {
  description = "List of trusted root certificates. The needed values for each trusted root certificates are 'name' and 'data'."
  type        = list(map(string))
  default     = []
}

variable "appgw_backend_pools" {
  description = "List of maps including backend pool configurations"
  type        = any
}

variable "appgw_http_listeners" {
  description = "List of maps including http listeners configurations"
  type        = list(map(string))
}

variable "ssl_certificates_configs" {
  description = "List of maps including ssl certificates configurations"
  type        = list(map(string))
  default     = []
}

variable "appgw_routings" {
  description = "List of maps including request routing rules configurations"
  type        = list(map(string))
  default     = []
}

variable "appgw_probes" {
  description = "List of maps including request probes configurations"
  type        = any
  default     = []
}

variable "appgw_backend_http_settings" {
  description = "List of maps including backend http settings configurations"
  type        = any
}

variable "appgw_url_path_map" {
  description = "List of maps including url path map configurations"
  type        = any
  default     = []
}

variable "appgw_redirect_configuration" {
  description = "List of maps including redirect configurations"
  type        = list(map(string))
  default     = []
}

### REWRITE RULE SET

variable "appgw_rewrite_rule_set" {
  description = "List of rewrite rule set including rewrite rules"
  type        = any
  default     = []
}

### WAF

variable "enabled_waf" {
  description = "Boolean to enable WAF."
  type        = bool
  default     = true
}

variable "file_upload_limit_mb" {
  description = " The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB."
  type        = number
  default     = 100
}

variable "waf_mode" {
  description = "The Web Application Firewall Mode. Possible values are Detection and Prevention."
  type        = string
  default     = "Prevention"
}

variable "max_request_body_size_kb" {
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB."
  type        = number
  default     = 128
}

variable "request_body_check" {
  description = "Is Request Body Inspection enabled?"
  type        = bool
  default     = true
}

variable "rule_set_type" {
  description = "The Type of the Rule Set used for this Web Application Firewall."
  type        = string
  default     = "OWASP"
}

variable "rule_set_version" {
  description = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1."
  type        = number
  default     = 3.1
}

variable "disabled_rule_group_settings" {
  description = "The rule group where specific rules should be disabled. Accepted values can be found here: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#rule_group_name"
  type = list(object({
    rule_group_name = string
    rules           = list(string)
  }))
  default = []
}

variable "waf_exclusion_settings" {
  description = "WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#match_variable"
  type        = list(map(string))
  default     = []
}

### LOGGING

variable "enable_logging" {
  description = "Boolean flag to specify whether logging is enabled"
  type        = bool
  default     = true
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = string
  default     = "30"
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = null
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = null
}

### NETWORKING

variable "create_vnet" {
  description = "Boolean to create virtual network with this module."
  type        = bool
  default     = true
}

variable "custom_vnet_name" {
  description = "Custom name for the virtual network."
  type        = string
  default     = null
}

variable "custom_vnet_cidr" {
  description = "Custom CIDR for the virtual network."
  type        = string
  default     = ""
}

variable "create_subnet" {
  description = "Boolean to create subnet with this module."
  type        = bool
  default     = true
}

variable "custom_subnet_name" {
  description = "Custom name for the subnet."
  type        = string
  default     = ""
}

variable "custom_subnet_cidr" {
  description = "Custom CIDR for the subnet."
  type        = string
  default     = ""
}

variable "custom_nsg_name" {
  description = "Custom name for the network security group."
  type        = string
  default     = null
}

variable "custom_nsg_https_name" {
  description = "Custom name for the network security group for HTTPS protocol."
  type        = string
  default     = null
}
