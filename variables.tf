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

# PUBLIC IP

variable "ip_sku" {
  description = "SKU for the public IP. Warning, can only be `Standard` for the moment."
  type        = string
  default     = "Standard"
}

variable "ip_allocation_method" {
  description = "Allocation method for the public IP. Warning, can only be `Static` for the moment."
  type        = string
  default     = "Static"
}

# Application gateway inputs

variable "sku_capacity" {
  description = "The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale_configuration is set"
  type        = number
  default     = 2
}

variable "sku" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_v2 and WAF_v2."
  type        = string
  default     = "WAF_v2"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs"
  type        = list(number)
  default     = [1, 2, 3]
}

variable "frontend_port_settings" {
  description = "Frontend port settings. Each port setting contains the name and the port for the frontend port."
  type = list(object({
    name = string
    port = number
  }))
}

variable "ssl_policy" {
  description = "Application Gateway SSL configuration. The list of available policies can be found here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#disabled_protocols"
  type = object({
    disabled_protocols   = optional(list(string), [])
    policy_type          = optional(string, "Predefined")
    policy_name          = optional(string, "AppGwSslPolicy20170401S")
    cipher_suites        = optional(list(string), [])
    min_protocol_version = optional(string, "TLSv1_2")
  })
  default = null
}

variable "ssl_profile" {
  description = "Application Gateway SSL profile. Default profile is used when this variable is set to null. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#name"
  type = object({
    name                             = string
    trusted_client_certificate_names = optional(string)
    verify_client_cert_issuer_dn     = optional(bool, false)
    ssl_policy = optional(object({
      disabled_protocols   = optional(list(string), [])
      policy_type          = optional(string, "Predefined")
      policy_name          = optional(string, "AppGwSslPolicy20170401S")
      cipher_suites        = optional(list(string), [])
      min_protocol_version = optional(string, "TLSv1_2")
    }))
  })
  default = null
}

variable "firewall_policy_id" {
  description = "ID of a Web Application Firewall Policy"
  type        = string
  default     = null
}

variable "trusted_root_certificate_configs" {
  description = "List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate)."
  type = list(object({
    name                = string
    data                = optional(string)
    file_path           = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "appgw_backend_pools" {
  description = "List of objects with backend pool configurations."
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "appgw_http_listeners" {
  description = "List of objects with HTTP listeners configurations and custom error configurations."
  type = list(object({
    name = string

    frontend_ip_configuration_name = optional(string)
    frontend_port_name             = optional(string)
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    protocol                       = optional(string, "Https")
    require_sni                    = optional(bool, false)
    ssl_certificate_name           = optional(string)
    ssl_profile_name               = optional(string)
    firewall_policy_id             = optional(string)

    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })), [])
  }))
}

variable "custom_error_configuration" {
  description = "List of objects with global level custom error configurations."
  type = list(object({
    status_code           = string
    custom_error_page_url = string
  }))
  default = []
}

variable "ssl_certificates_configs" {
  description = <<EOD
List of objects with SSL certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "appgw_routings" {
  description = "List of objects with request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory."
  type = list(object({
    name                        = string
    rule_type                   = optional(string, "Basic")
    http_listener_name          = optional(string)
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    url_path_map_name           = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    priority                    = optional(number)
  }))
}

variable "appgw_probes" {
  description = "List of objects with probes configurations."
  type = list(object({
    name     = string
    host     = optional(string)
    port     = optional(number, 443)
    interval = optional(number, 30)
    path     = optional(string, "/")
    protocol = optional(string, "Https")
    timeout  = optional(number, 30)

    unhealthy_threshold                       = optional(number, 3)
    pick_host_name_from_backend_http_settings = optional(bool, false)
    minimum_servers                           = optional(number, 0)

    match = optional(object({
      body        = optional(string, "")
      status_code = optional(list(string), ["200-399"])
    }), {})
  }))
  default = []
}

variable "appgw_backend_http_settings" {
  description = "List of objects including backend http settings configurations."
  type = list(object({
    name     = string
    port     = optional(number, 443)
    protocol = optional(string, "Https")

    path       = optional(string)
    probe_name = optional(string)

    cookie_based_affinity               = optional(string, "Disabled")
    affinity_cookie_name                = optional(string, "ApplicationGatewayAffinity")
    request_timeout                     = optional(number, 20)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool, true)
    trusted_root_certificate_names      = optional(list(string), [])

    connection_draining_timeout_sec = optional(number)
  }))
}

variable "appgw_url_path_map" {
  description = "List of objects with URL path map configurations."
  type = list(object({
    name = string

    default_backend_address_pool_name   = optional(string)
    default_redirect_configuration_name = optional(string)
    default_backend_http_settings_name  = optional(string)
    default_rewrite_rule_set_name       = optional(string)

    path_rules = list(object({
      name = string

      backend_address_pool_name  = optional(string)
      backend_http_settings_name = optional(string)
      rewrite_rule_set_name      = optional(string)

      paths = optional(list(string), [])
    }))
  }))
  default = []
}

variable "appgw_redirect_configuration" {
  description = "List of objects with redirect configurations."
  type = list(object({
    name = string

    redirect_type        = optional(string, "Permanent")
    target_listener_name = optional(string)
    target_url           = optional(string)

    include_path         = optional(bool, true)
    include_query_string = optional(bool, true)
  }))
  default = []
}

### REWRITE RULE SET

variable "appgw_rewrite_rule_set" {
  description = "List of rewrite rule set objects with rewrite rules."
  type = list(object({
    name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = string

      conditions = optional(list(object({
        variable    = string
        pattern     = string
        ignore_case = optional(bool, false)
        negate      = optional(bool, false)
      })), [])

      response_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])

      request_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])

      url_reroute = optional(object({
        path         = optional(string)
        query_string = optional(string)
        components   = optional(string)
        reroute      = optional(bool)
      }))
    }))
  }))
  default = []
}

### WAF

variable "force_firewall_policy_association" {
  description = "Enable if the Firewall Policy is associated with the Application Gateway."
  type        = bool
  default     = false
}

variable "waf_configuration" {
  description = <<EOD
Map of WAF configuration parameters:
```
- enabled:                  Boolean to enable WAF.
- file_upload_limit_mb:     The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB.
- firewall_mode:            The Web Application Firewall Mode. Possible values are Detection and Prevention.
- max_request_body_size_kb: The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB.
- request_body_check:       Is Request Body Inspection enabled ?
- rule_set_type:            The Type of the Rule Set used for this Web Application Firewall.
- rule_set_version:         The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1.
- disabled_rule_group:      The rule group where specific rules should be disabled. Accepted values can be found here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#rule_group_name
- exclusion:                WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#match_variable
```
EOD
  type = object({
    enabled                  = bool
    file_upload_limit_mb     = optional(number)
    firewall_mode            = string
    max_request_body_size_kb = optional(number)
    request_body_check       = optional(bool)
    rule_set_type            = string
    rule_set_version         = string
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = list(string)
    })))
    exclusion = optional(list(object({
      match_variable          = string
      selector                = optional(string)
      selector_match_operator = optional(string)
    })))
  })
  default = {
    enabled                  = true
    file_upload_limit_mb     = 100
    firewall_mode            = "Prevention"
    max_request_body_size_kb = 128
    request_body_check       = true
    rule_set_type            = "OWASP"
    rule_set_version         = 3.1
  }
}

variable "disable_waf_rules_for_dev_portal" {
  description = "Whether to disable some WAF rules if the APIM developer portal is hosted behind this Application Gateway. See locals.tf for the documentation link."
  type        = bool
  default     = false
}

### NETWORKING

variable "virtual_network_name" {
  description = "Virtual network name to attach the subnet."
  type        = string
}

variable "subnet_resource_group_name" {
  description = "Resource group name of the subnet."
  type        = string
  default     = ""
}

variable "create_subnet" {
  description = "Boolean to create subnet with this module."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Custom subnet ID for attaching the Application Gateway. Used only when the variable `create_subnet = false`."
  type        = string
  default     = ""
}

variable "route_table_name" {
  description = "The Route Table name to associate with the subnet"
  type        = string
  default     = null
}

variable "route_table_rg" {
  description = "The Route Table RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "subnet_cidr" {
  description = "Subnet CIDR to create."
  type        = string
  default     = ""
}

variable "create_nsg" {
  description = "Boolean to create the network security group."
  type        = bool
  default     = false
}

variable "create_nsg_https_rule" {
  description = "Boolean to create the network security group rule opening https to everyone."
  type        = bool
  default     = true
}

variable "create_nsg_healthprobe_rule" {
  description = "Boolean to create the network security group rule for the health probes."
  type        = bool
  default     = true
}

variable "nsr_https_source_address_prefix" {
  description = "Source address prefix to allow to access on port 443 defined in dedicated network security rule."
  type        = string
  default     = "*"
}

### IDENTITY

variable "user_assigned_identity_id" {
  description = "User assigned identity id assigned to this resource."
  type        = string
  default     = null
}

### APPGW PRIVATE

variable "appgw_private" {
  description = "Boolean variable to create a private Application Gateway. When `true`, the default http listener will listen on private IP instead of the public IP."
  type        = bool
  default     = false
}

variable "appgw_private_ip" {
  description = "Private IP for Application Gateway. Used when variable `appgw_private` is set to `true`."
  type        = string
  default     = null
}

variable "enable_http2" {
  description = "Whether to enable http2 or not"
  type        = bool
  default     = true
}

### Autoscaling

variable "autoscaling_parameters" {
  description = "Map containing autoscaling parameters. Must contain at least min_capacity"
  type = object({
    min_capacity = number
    max_capacity = optional(number, 5)
  })
  default = null
}
