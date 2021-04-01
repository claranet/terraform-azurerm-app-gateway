resource "azurerm_application_gateway" "app_gateway" {
  location            = var.location
  resource_group_name = var.resource_group_name

  name = local.appgw_name

  #
  # Common
  #

  sku {
    capacity = var.autoscaling_parameters != null ? null : var.sku_capacity
    name     = var.sku
    tier     = var.sku
  }

  zones = var.zones

  enable_http2 = var.enable_http2

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.appgw_private ? ["fake"] : []
    content {
      name                          = local.frontend_priv_ip_configuration_name
      private_ip_address_allocation = var.appgw_private ? "Static" : null
      private_ip_address            = var.appgw_private ? var.appgw_private_ip : null
      subnet_id                     = var.appgw_private ? local.subnet_id : null
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port_settings
    content {
      name = lookup(frontend_port.value, "name", null)
      port = lookup(frontend_port.value, "port", null)
    }
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.create_subnet ? module.azure-network-subnet.subnet_ids[0] : var.subnet_id
  }

  #
  # Security
  #

  dynamic "waf_configuration" {
    for_each = local.enable_waf ? ["fake"] : []
    content {
      enabled                  = var.enable_waf
      file_upload_limit_mb     = coalesce(var.file_upload_limit_mb, 100)
      firewall_mode            = coalesce(var.waf_mode, "Prevention")
      max_request_body_size_kb = coalesce(var.max_request_body_size_kb, 128)
      request_body_check       = var.request_body_check
      rule_set_type            = var.rule_set_type
      rule_set_version         = var.rule_set_version

      dynamic "disabled_rule_group" {
        for_each = local.disabled_rule_group_settings
        content {
          rule_group_name = lookup(disabled_rule_group.value, "rule_group_name", null)
          rules           = lookup(disabled_rule_group.value, "rules", null)
        }
      }

      dynamic "exclusion" {
        for_each = var.waf_exclusion_settings
        content {
          match_variable          = lookup(exclusion.value, "match_variable", null)
          selector                = lookup(exclusion.value, "selector", null)
          selector_match_operator = lookup(exclusion.value, "selector_match_operator", null)
        }
      }
    }
  }

  dynamic "ssl_policy" {
    for_each = var.ssl_policy == null ? [] : [1]
    content {
      disabled_protocols   = lookup(var.ssl_policy, "disabled_protocols", [])
      policy_type          = lookup(var.ssl_policy, "policy_type", "Predefined")
      policy_name          = lookup(var.ssl_policy, "policy_type") == "Predefined" ? lookup(var.ssl_policy, "policy_name", "AppGwSslPolicy20170401S") : null
      cipher_suites        = lookup(var.ssl_policy, "cipher_suites", [])
      min_protocol_version = lookup(var.ssl_policy, "min_protocol_version", null)
    }
  }

  #
  # Autoscaling
  #

  dynamic "autoscale_configuration" {
    for_each = toset(var.autoscaling_parameters != null ? ["fake"] : [])
    content {
      min_capacity = lookup(var.autoscaling_parameters, "min_capacity")
      max_capacity = lookup(var.autoscaling_parameters, "max_capacity", 5)
    }
  }

  #
  # Backend HTTP settings
  #

  dynamic "backend_http_settings" {
    for_each = var.appgw_backend_http_settings
    content {
      name       = lookup(backend_http_settings.value, "name", null)
      path       = lookup(backend_http_settings.value, "path", "")
      probe_name = lookup(backend_http_settings.value, "probe_name", null)

      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", "ApplicationGatewayAffinity")
      cookie_based_affinity               = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", true)
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      port                                = lookup(backend_http_settings.value, "port", 443)
      protocol                            = lookup(backend_http_settings.value, "protocol", "Https")
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 20)
      trusted_root_certificate_names      = lookup(backend_http_settings.value, "trusted_root_certificate_names", [])
    }
  }

  #
  # HTTP listener
  #

  dynamic "http_listener" {
    for_each = var.appgw_http_listeners
    content {
      name                           = lookup(http_listener.value, "name", null)
      frontend_ip_configuration_name = lookup(http_listener.value, "frontend_ip_conf", var.appgw_private ? local.frontend_priv_ip_configuration_name : local.frontend_ip_configuration_name)
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name", null)
      protocol                       = lookup(http_listener.value, "protocol", "Https")
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      host_name                      = lookup(http_listener.value, "host_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", null)
      firewall_policy_id             = lookup(http_listener.value, "firewall_policy_id", null)
      dynamic "custom_error_configuration" {
        for_each = lookup(http_listener.value, "custom_error_configuration", {})
        content {
          custom_error_page_url = lookup(custom_error_configuration.value, "custom_error_page_url", null)
          status_code           = lookup(custom_error_configuration.value, "status_code", null)
        }
      }
    }
  }

  #
  # Custom error configuration
  #
  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configuration
    content {
      custom_error_page_url = lookup(custom_error_configuration.value, "custom_error_page_url", null)
      status_code           = lookup(custom_error_configuration.value, "status_code", null)
    }
  }

  #
  # Backend address pool
  #

  dynamic "backend_address_pool" {
    for_each = var.appgw_backend_pools
    content {
      name         = lookup(backend_address_pool.value, "name", null)
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  #
  # SSL certificate
  #

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates_configs
    content {
      name                = lookup(ssl_certificate.value, "name", null)
      data                = lookup(ssl_certificate.value, "data", null)
      password            = lookup(ssl_certificate.value, "password", null)
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  #
  # Trusted root certificate
  #

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificate_configs
    content {
      name = lookup(trusted_root_certificate.value, "name", null)
      data = filebase64(lookup(trusted_root_certificate.value, "data", null))
    }
  }

  #
  # Request routing rule
  #

  dynamic "request_routing_rule" {
    for_each = var.appgw_routings
    content {
      name      = lookup(request_routing_rule.value, "name", null)
      rule_type = lookup(request_routing_rule.value, "rule_type", "Basic")

      http_listener_name          = lookup(request_routing_rule.value, "http_listener_name", lookup(request_routing_rule.value, "name", null))
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", lookup(request_routing_rule.value, "name", null))
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", lookup(request_routing_rule.value, "name", null))
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  #
  # Rewrite rule set
  #

  dynamic "rewrite_rule_set" {
    for_each = var.appgw_rewrite_rule_set
    content {
      name = lookup(rewrite_rule_set.value, "name", null)
      dynamic "rewrite_rule" {
        for_each = lookup(rewrite_rule_set.value, "rewrite_rule", null)
        content {
          name          = lookup(rewrite_rule.value, "name", null)
          rule_sequence = lookup(rewrite_rule.value, "rule_sequence", null)

          condition {
            ignore_case = lookup(rewrite_rule.value, "condition_ignore_case", null)
            negate      = lookup(rewrite_rule.value, "condition_negate", null)
            pattern     = lookup(rewrite_rule.value, "condition_pattern", null)
            variable    = lookup(rewrite_rule.value, "condition_variable", null)
          }

          response_header_configuration {
            header_name  = lookup(rewrite_rule.value, "response_header_name", null)
            header_value = lookup(rewrite_rule.value, "response_header_value", null)
          }
        }
      }
    }
  }

  #
  # Probe
  #

  dynamic "probe" {
    for_each = var.appgw_probes
    content {
      host                                      = lookup(probe.value, "host", null)
      interval                                  = lookup(probe.value, "interval", 30)
      name                                      = lookup(probe.value, "name", null)
      path                                      = lookup(probe.value, "path", "/")
      protocol                                  = lookup(probe.value, "protocol", "Https")
      timeout                                   = lookup(probe.value, "timeout", 30)
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", false)
      unhealthy_threshold                       = lookup(probe.value, "unhealthy_threshold", 3)
      match {
        body        = lookup(probe.value, "match_body", "")
        status_code = lookup(probe.value, "match_status_code", ["200-399"])
      }
    }
  }

  #
  # URL path map
  #

  dynamic "url_path_map" {
    for_each = var.appgw_url_path_map
    content {
      name                                = lookup(url_path_map.value, "name", null)
      default_backend_address_pool_name   = lookup(url_path_map.value, "default_backend_address_pool_name", null)
      default_redirect_configuration_name = lookup(url_path_map.value, "default_redirect_configuration_name", null)
      default_backend_http_settings_name  = lookup(url_path_map.value, "default_backend_http_settings_name", lookup(url_path_map.value, "default_backend_address_pool_name", null))

      dynamic "path_rule" {
        for_each = lookup(url_path_map.value, "path_rule")
        content {
          name                       = lookup(path_rule.value, "path_rule_name", null)
          backend_address_pool_name  = lookup(path_rule.value, "backend_address_pool_name", lookup(path_rule.value, "path_rule_name", null))
          backend_http_settings_name = lookup(path_rule.value, "backend_http_settings_name", lookup(path_rule.value, "path_rule_name", null))
          paths                      = [lookup(path_rule.value, "paths", null)]
        }
      }
    }
  }

  #
  # Redirect configuration
  #

  dynamic "redirect_configuration" {
    for_each = var.appgw_redirect_configuration
    content {
      name                 = lookup(redirect_configuration.value, "name", null)
      redirect_type        = lookup(redirect_configuration.value, "redirect_type", "Permanent")
      target_listener_name = lookup(redirect_configuration.value, "target_listener_name", null)
      target_url           = lookup(redirect_configuration.value, "target_url", null)
      include_path         = lookup(redirect_configuration.value, "include_path", "true")
      include_query_string = lookup(redirect_configuration.value, "include_query_string", "true")
    }
  }

  #
  # Identity
  #

  dynamic "identity" {
    for_each = var.user_assigned_identity_id != null ? ["fake"] : []
    content {
      type         = "UserAssigned"
      identity_ids = [var.user_assigned_identity_id]
    }
  }

  #
  # Tags
  #

  tags = merge(local.default_tags, var.app_gateway_tags)
}
