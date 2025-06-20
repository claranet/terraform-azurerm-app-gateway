variable "user_assigned_identity_id" {
  description = "User assigned identity id assigned to this resource."
  type        = string
  default     = null
}

variable "autoscale_configuration" {
  description = "Map containing autoscaling parameters. Must contain at least min_capacity."
  type = object({
    min_capacity = number
    max_capacity = optional(number, 5)
  })
  default = null
}

variable "sku_capacity" {
  description = "The capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale_configuration is set."
  type        = number
  default     = 2

  validation {
    condition     = var.sku_capacity > 0 && var.sku_capacity < 11
    error_message = "The capacity of the SKU must be between 1 and 10."
  }
}

variable "sku" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_v2 and WAF_v2."
  type        = string
  default     = "WAF_v2"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "http2_enabled" {
  description = "Whether to enable http2 or not."
  type        = bool
  default     = true
}

variable "frontend_private_ip_configuration" {
  description = "Configuration of frontend private IP."
  type = object({
    private_ip_address_allocation = optional(string, "Static")
    private_ip_address            = optional(string)
  })
  default = null
}

variable "frontend_ports" {
  description = "List of objects with frontend ports. Each one contains the name and the port for the frontend port."
  type = list(object({
    name = string
    port = number
  }))
  default  = []
  nullable = false
}

variable "ssl_policy" {
  description = "List of objects with SSL configurations. The list of available policies can be found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#disabled_protocols)."
  type = object({
    disabled_protocols   = optional(list(string), [])
    policy_type          = optional(string, "Predefined")
    policy_name          = optional(string, "AppGwSslPolicy20170401S")
    cipher_suites        = optional(list(string), [])
    min_protocol_version = optional(string, "TLSv1_2")
  })
  default = {}
}

variable "ssl_profiles" {
  description = "List of objects with SSL profiles. Default profile is used when this variable is set to null."
  type = list(object({
    name                             = string
    trusted_client_certificate_names = optional(list(string), [])
    verify_client_cert_issuer_dn     = optional(bool, false)
    ssl_policy = optional(object({
      disabled_protocols   = optional(list(string), [])
      policy_type          = optional(string, "Predefined")
      policy_name          = optional(string, "AppGwSslPolicy20170401S")
      cipher_suites        = optional(list(string), [])
      min_protocol_version = optional(string, "TLSv1_2")
    }))
  }))
  default  = []
  nullable = false
}

variable "firewall_policy_id" {
  description = "ID of a Web Application Firewall Policy."
  type        = string
  default     = null
}

variable "trusted_root_certificates" {
  description = "List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate)."
  type = list(object({
    name                = string
    data                = optional(string)
    file_path           = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "backend_address_pools" {
  description = "List of objects with backend pool configurations."
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "http_listeners" {
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

    custom_error_configurations = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })), [])
  }))
}

variable "custom_error_configurations" {
  description = "List of objects with global level custom error configurations."
  type = list(object({
    status_code           = string
    custom_error_page_url = string
  }))
  default = []
}

variable "ssl_certificates" {
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

variable "authentication_certificates" {
  description = <<EOD
List of objects with authentication certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_client_certificates" {
  description = <<EOD
List of objects with trusted client certificates configurations.
The path to a base-64 encoded certificate is expected in the 'data' attribute:
```
data = filebase64("./file_path")
```
EOD
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "request_routing_rules" {
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

variable "probes" {
  description = "List of objects with probes configurations."
  type = list(object({
    name     = string
    host     = optional(string)
    port     = optional(number, null)
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

variable "backend_http_settings" {
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
    authentication_certificate          = optional(string)

    connection_draining_timeout_sec = optional(number)
  }))
}

variable "url_path_maps" {
  description = "List of objects with URL path map configurations."
  type = list(object({
    name = string

    default_backend_address_pool_name   = optional(string)
    default_redirect_configuration_name = optional(string)
    default_backend_http_settings_name  = optional(string)
    default_rewrite_rule_set_name       = optional(string)

    path_rules = list(object({
      name = string

      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      rewrite_rule_set_name       = optional(string)
      redirect_configuration_name = optional(string)
      firewall_policy_id          = optional(string)

      paths = optional(list(string), [])
    }))
  }))
  default = []
}

variable "redirect_configurations" {
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

variable "rewrite_rule_sets" {
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

variable "force_firewall_policy_association" {
  description = "Enable if the Firewall Policy is associated with the Application Gateway."
  type        = bool
  default     = false
  nullable    = false
}
