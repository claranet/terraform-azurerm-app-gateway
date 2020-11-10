resource "azurerm_application_gateway" "app_gateway" {
  location            = var.location
  name                = local.application_gateway_name
  resource_group_name = var.resource_group_name
  enable_http2        = var.enable_http2

  #
  # Common
  #

  sku {
    name     = lookup(var.sku, "name")
    tier     = lookup(var.sku, "tier")
    capacity = lookup(var.sku, "capacity")
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = module.azure-network-subnet.subnet_ids[0]
  }

  dynamic "frontend_port" {
    for_each = toset(local.frontend_port)
    content {
      name = format("%s-%s", local.frontend_port_name, frontend_port.value)
      port = frontend_port.value
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration_settings
    content {
      enabled                  = lookup(waf_configuration.value, "enabled")
      firewall_mode            = lookup(waf_configuration.value, "firewall_mode", "Detection")
      file_upload_limit_mb     = lookup(waf_configuration.value, "file_upload_limit_mb", 100)
      max_request_body_size_kb = lookup(waf_configuration.value, "max_request_body_size_kb", 128)
      request_body_check       = lookup(waf_configuration.value, "request_body_check", "true")
      rule_set_type            = lookup(waf_configuration.value, "rule_set_type", "OWASP")
      rule_set_version         = lookup(waf_configuration.value, "rule_set_version", "3.1")

      dynamic "disabled_rule_group" {
        for_each = var.disabled_rule_group_settings
        content {
          rule_group_name = lookup(disabled_rule_group.value, "rule_group_name")
          rules           = lookup(disabled_rule_group.value, "rules")
        }
      }

      #
      # Exclusion configuration
      #

      dynamic "exclusion" {
        for_each = var.waf_exclusion
        content {
          selector                = lookup(exclusion.value, "selector")
          selector_match_operator = lookup(exclusion.value, "selector_match_operator")
          match_variable          = lookup(exclusion.value, "match_variable")
        }
      }
    }
  }

  dynamic "ssl_policy" {
    for_each = var.ssl_policy_settings
    content {
      disabled_protocols   = lookup(ssl_policy.value, "disabled_protocols", [])
      policy_type          = lookup(ssl_policy.value, "policy_type", "Predefined")
      policy_name          = lookup(ssl_policy.value, "policy_name", "AppGwSslPolicy20170401S")
      cipher_suites        = lookup(ssl_policy.value, "cipher_suites", null)
      min_protocol_version = lookup(ssl_policy.value, "min_protocol_version", null)
    }
  }

  #
  # HTTP listener
  #

  dynamic "http_listener" {
    for_each = var.appgw_http_listeners
    content {
      name                           = format("%s-%s", local.listener_name, lookup(http_listener.value, "name"))
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = format("%s-%s", local.frontend_port_name, lookup(http_listener.value, "port"))
      host_name                      = lookup(http_listener.value, "host_name")
      protocol                       = lookup(http_listener.value, "protocol")
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", null)
    }
  }

  #
  # Backend address pool
  #

  dynamic "backend_address_pool" {
    for_each = var.appgw_backend_pools
    content {
      name  = format("%s-%s", local.backend_address_pool_name, lookup(backend_address_pool.value, "name"))
      fqdns = lookup(backend_address_pool.value, "fqdns")
    }
  }

  #
  # Backend HTTP settings
  #

  dynamic "backend_http_settings" {
    for_each = var.appgw_backend_http_settings
    content {
      name       = format("%s-%s", local.http_setting_name, lookup(backend_http_settings.value, "name"))
      path       = lookup(backend_http_settings.value, "path", "")
      probe_name = lookup(backend_http_settings.value, "probe_name", null)

      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", "ApplicationGatewayAffinity")
      cookie_based_affinity               = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", true)
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      port                                = lookup(backend_http_settings.value, "port")
      protocol                            = lookup(backend_http_settings.value, "protocol")
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 20)

      authentication_certificate {
        name = lookup(backend_http_settings.value, "authentication_certificate_name", null)
      }
    }
  }

  #
  # URL path map
  #

  dynamic "url_path_map" {
    for_each = var.appgw_url_path_map
    content {
      name                               = format("%s-%s", local.url_path_map_name, lookup(request_routing_rule.value, "url_path_map_name"))
      default_backend_address_pool_name  = lookup(url_path_map.value, "default_backend_address_pool_name")
      default_backend_http_settings_name = lookup(url_path_map.value, "default_backend_address_pool_name")

      dynamic "path_rule" {
        for_each = lookup(url_path_map.value, "path_rule")
        content {
          name                       = lookup(path_rule.value, "name")
          backend_address_pool_name  = format("%s-%s", local.backend_address_pool_name, lookup(path_rule.value, "backend_address_pool_name"))
          backend_http_settings_name = format("%s-%s", local.http_setting_name, lookup(path_rule.value, "backend_http_settings_name"))
          paths                      = lookup(path_rule.value, "paths")
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
      name                 = format("%s-%s", local.redirect_configuration_name, lookup(redirect_configuration.value, "name"))
      redirect_type        = lookup(redirect_configuration.value, "redirect_type", "Permanent")
      target_listener_name = lookup(redirect_configuration.value, "target_listener_name")
      include_path         = "true"
      include_query_string = "true"
    }
  }


  #
  # Request routing rule
  #

  dynamic "request_routing_rule" {
    for_each = var.appgw_routings
    content {
      name      = format("%s-%s", local.request_routing_rule_name, lookup(request_routing_rule.value, "name"))
      rule_type = lookup(request_routing_rule.value, "rule_type", "Basic")

      http_listener_name          = format("%s-%s", local.listener_name, lookup(request_routing_rule.value, "http_listener_name"))
      backend_address_pool_name   = format("%s-%s", local.backend_address_pool_name, lookup(request_routing_rule.value, "backend_address_pool_name"))
      backend_http_settings_name  = format("%s-%s", local.http_setting_name, lookup(request_routing_rule.value, "backend_http_settings_name"))
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name") == null ? lookup(request_routing_rule.value, "url_path_map_name") : format("%s-%s", local.url_path_map_name, lookup(request_routing_rule.value, "url_path_map_name"))
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name") == null ? lookup(request_routing_rule.value, "redirect_configuration_name") : format("%s-%s", local.url_path_map_name, lookup(request_routing_rule.value, "redirect_configuration_name"))
    }
  }

  #
  # Probe
  #

  dynamic "probe" {
    for_each = var.appgw_probes
    content {
      host                = lookup(probe.value, "host")
      interval            = lookup(probe.value, "interval", 30)
      name                = lookup(probe.value, "name")
      path                = lookup(probe.value, "path", "/")
      protocol            = lookup(probe.value, "protocol", "Https")
      timeout             = lookup(probe.value, "timeout", 30)
      unhealthy_threshold = lookup(probe.value, "unhealthy_threshold", 3)
    }
  }

  #
  # SSL certificate
  #

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates_configs
    content {
      name     = lookup(ssl_certificate.value, "name")
      data     = filebase64(lookup(ssl_certificate.value, "data"))
      password = lookup(ssl_certificate.value, "password")
    }
  }

  #
  # Authentication certificate
  #

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificate_configs
    content {
      name = lookup(authentication_certificate.value, "name")
      data = filebase64(lookup(authentication_certificate.value, "data"))
    }
  }

  tags = merge(local.default_tags, var.extra_tags)
}
