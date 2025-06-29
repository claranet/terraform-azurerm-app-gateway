resource "azurerm_application_gateway" "main" {
  location            = var.location
  resource_group_name = var.resource_group_name

  name = local.name

  sku {
    capacity = var.autoscale_configuration == null ? var.sku_capacity : null
    name     = var.sku
    tier     = var.sku
  }

  zones = var.zones

  firewall_policy_id = var.firewall_policy_id

  enable_http2 = var.http2_enabled

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.main.id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_private_ip_configuration[*]
    content {
      name                          = local.frontend_priv_ip_configuration_name
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      subnet_id                     = local.subnet_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = local.subnet_id
  }

  force_firewall_policy_association = var.force_firewall_policy_association

  dynamic "ssl_policy" {
    for_each = var.ssl_policy[*]
    content {
      disabled_protocols   = ssl_policy.value.disabled_protocols
      policy_type          = ssl_policy.value.policy_type
      policy_name          = ssl_policy.value.policy_type == "Predefined" ? ssl_policy.value.policy_name : null
      cipher_suites        = ssl_policy.value.policy_type == "Custom" ? ssl_policy.value.cipher_suites : null
      min_protocol_version = ssl_policy.value.policy_type == "Custom" ? ssl_policy.value.min_protocol_version : null
    }
  }

  dynamic "ssl_profile" {
    for_each = var.ssl_profiles
    content {
      name                             = ssl_profile.value.name
      trusted_client_certificate_names = ssl_profile.value.trusted_client_certificate_names
      verify_client_cert_issuer_dn     = ssl_profile.value.verify_client_cert_issuer_dn
      dynamic "ssl_policy" {
        for_each = ssl_profile.value.ssl_policy[*]
        content {
          disabled_protocols   = ssl_profile.value.ssl_policy.disabled_protocols
          policy_type          = ssl_profile.value.ssl_policy.policy_type
          policy_name          = ssl_profile.value.ssl_policy.policy_type == "Predefined" ? ssl_profile.value.ssl_policy.policy_name : null
          cipher_suites        = strcontains(ssl_profile.value.ssl_policy.policy_type, "Custom") ? ssl_profile.value.ssl_policy.cipher_suites : null
          min_protocol_version = strcontains(ssl_profile.value.ssl_policy.policy_type, "Custom") ? ssl_profile.value.ssl_policy.min_protocol_version : null
        }
      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificates
    content {
      name = authentication_certificate.value.name
      data = authentication_certificate.value.data
    }
  }

  dynamic "trusted_client_certificate" {
    for_each = var.trusted_client_certificates
    content {
      name = trusted_client_certificate.value.name
      data = trusted_client_certificate.value.data
    }
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration[*]
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    iterator = back_http_set
    content {
      name     = back_http_set.value.name
      port     = back_http_set.value.port
      protocol = back_http_set.value.protocol

      path       = back_http_set.value.path
      probe_name = back_http_set.value.probe_name

      cookie_based_affinity               = back_http_set.value.cookie_based_affinity
      affinity_cookie_name                = back_http_set.value.affinity_cookie_name
      request_timeout                     = back_http_set.value.request_timeout
      host_name                           = back_http_set.value.host_name
      pick_host_name_from_backend_address = back_http_set.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = back_http_set.value.trusted_root_certificate_names

      dynamic "authentication_certificate" {
        for_each = back_http_set.value.authentication_certificate[*]
        content {
          name = authentication_certificate.value
        }
      }

      dynamic "connection_draining" {
        for_each = back_http_set.value.connection_draining_timeout_sec[*]
        content {
          enabled           = true
          drain_timeout_sec = connection_draining.value
        }
      }
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    iterator = http_listen
    content {
      name = http_listen.value.name
      frontend_ip_configuration_name = coalesce(http_listen.value.frontend_ip_configuration_name,
        var.frontend_private_ip_configuration != null ? local.frontend_priv_ip_configuration_name :
        local.frontend_ip_configuration_name
      )
      frontend_port_name   = http_listen.value.frontend_port_name
      host_name            = http_listen.value.host_name
      host_names           = http_listen.value.host_names
      protocol             = http_listen.value.protocol
      require_sni          = http_listen.value.require_sni
      ssl_certificate_name = http_listen.value.ssl_certificate_name
      ssl_profile_name     = http_listen.value.ssl_profile_name
      firewall_policy_id   = http_listen.value.firewall_policy_id

      dynamic "custom_error_configuration" {
        for_each = http_listen.value.custom_error_configurations
        iterator = err_conf
        content {
          status_code           = err_conf.value.status_code
          custom_error_page_url = err_conf.value.custom_error_page_url
        }
      }
    }
  }

  dynamic "custom_error_configuration" {
    for_each = var.custom_error_configurations
    iterator = err_conf
    content {
      status_code           = err_conf.value.status_code
      custom_error_page_url = err_conf.value.custom_error_page_url
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    iterator = back_pool
    content {
      name         = back_pool.value.name
      fqdns        = back_pool.value.fqdns
      ip_addresses = back_pool.value.ip_addresses
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    iterator = ssl_crt
    content {
      name                = ssl_crt.value.name
      data                = ssl_crt.value.data
      password            = ssl_crt.value.password
      key_vault_secret_id = ssl_crt.value.key_vault_secret_id
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = var.trusted_root_certificates
    iterator = ssl_crt
    content {
      name                = ssl_crt.value.name
      data                = ssl_crt.value.data == null ? try(filebase64(ssl_crt.value.file_path), null) : ssl_crt.value.data
      key_vault_secret_id = ssl_crt.value.key_vault_secret_id
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    iterator = routing
    content {
      name      = routing.value.name
      rule_type = routing.value.rule_type

      http_listener_name          = coalesce(routing.value.http_listener_name, routing.value.name)
      backend_address_pool_name   = routing.value.backend_address_pool_name
      backend_http_settings_name  = routing.value.backend_http_settings_name
      url_path_map_name           = routing.value.url_path_map_name
      redirect_configuration_name = routing.value.redirect_configuration_name
      rewrite_rule_set_name       = routing.value.rewrite_rule_set_name
      priority                    = coalesce(routing.value.priority, routing.key + 1)
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    content {
      name = rewrite_rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rules
        iterator = rule
        content {
          name          = rule.value.name
          rule_sequence = rule.value.rule_sequence

          dynamic "condition" {
            for_each = rule.value.conditions
            iterator = cond
            content {
              variable    = cond.value.variable
              pattern     = cond.value.pattern
              ignore_case = cond.value.ignore_case
              negate      = cond.value.negate
            }
          }

          dynamic "response_header_configuration" {
            for_each = rule.value.response_header_configurations
            iterator = header
            content {
              header_name  = header.value.header_name
              header_value = header.value.header_value
            }
          }

          dynamic "request_header_configuration" {
            for_each = rule.value.request_header_configurations
            iterator = header
            content {
              header_name  = header.value.header_name
              header_value = header.value.header_value
            }
          }

          dynamic "url" {
            for_each = rule.value.url_reroute[*]
            content {
              path         = url.value.path
              query_string = url.value.query_string
              components   = url.value.components
              reroute      = url.value.reroute
            }
          }
        }
      }
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name = probe.value.name

      host     = probe.value.host
      port     = probe.value.port
      interval = probe.value.interval

      path     = probe.value.path
      protocol = probe.value.protocol
      timeout  = probe.value.timeout

      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      minimum_servers                           = probe.value.minimum_servers
      match {
        body        = probe.value.match.body
        status_code = probe.value.match.status_code
      }
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_maps
    content {
      name                                = url_path_map.value.name
      default_redirect_configuration_name = url_path_map.value.default_backend_address_pool_name == null && url_path_map.value.default_backend_http_settings_name == null ? url_path_map.value.default_redirect_configuration_name : null
      default_backend_address_pool_name   = url_path_map.value.default_redirect_configuration_name == null ? url_path_map.value.default_backend_address_pool_name : null
      default_backend_http_settings_name  = url_path_map.value.default_redirect_configuration_name == null ? coalesce(url_path_map.value.default_backend_http_settings_name, url_path_map.value.default_backend_address_pool_name) : null
      default_rewrite_rule_set_name       = url_path_map.value.default_rewrite_rule_set_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules
        content {
          name                        = path_rule.value.name
          backend_address_pool_name   = path_rule.value.redirect_configuration_name == null ? coalesce(path_rule.value.backend_address_pool_name, path_rule.value.name) : null
          backend_http_settings_name  = path_rule.value.redirect_configuration_name == null ? coalesce(path_rule.value.backend_http_settings_name, path_rule.value.name) : null
          rewrite_rule_set_name       = path_rule.value.rewrite_rule_set_name
          redirect_configuration_name = path_rule.value.redirect_configuration_name
          paths                       = path_rule.value.paths
          firewall_policy_id          = path_rule.value.firewall_policy_id
        }
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    iterator = redirect
    content {
      name                 = redirect.value.name
      redirect_type        = redirect.value.redirect_type
      target_listener_name = redirect.value.target_listener_name
      target_url           = redirect.value.target_url
      include_path         = redirect.value.include_path
      include_query_string = redirect.value.include_query_string
    }
  }

  dynamic "identity" {
    for_each = var.user_assigned_identity_id[*]
    content {
      type         = "UserAssigned"
      identity_ids = identity.value[*]
    }
  }

  tags = local.app_gateway_tags
}

moved {
  from = azurerm_application_gateway.app_gateway
  to   = azurerm_application_gateway.main
}
