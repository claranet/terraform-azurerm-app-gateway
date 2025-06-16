module "azure_virtual_network" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.name

  cidrs = ["192.168.0.0/16"]
}

locals {
  base_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}"
}

module "appgw" {
  source  = "claranet/app-gateway/azurerm"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.name

  virtual_network_name = module.azure_virtual_network.name
  subnet_cidr          = "192.168.1.0/24"

  backend_http_settings = [
    {
      name                  = "${local.base_name}-backhttpsettings-http"
      cookie_based_affinity = "Disabled"
      path                  = "/"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 300
    },
    # {
    #   name                  = "${local.base_name}-backhttpsettings-https"
    #   cookie_based_affinity = "Disabled"
    #   path                  = "/"
    #   port                  = 443
    #   protocol              = "Https"
    #   request_timeout       = 300
    # }
  ]

  backend_address_pools = [{
    name  = "${local.base_name}-backendpool"
    fqdns = ["example.com"]
  }]

  request_routing_rules = [
    {
      name                       = "${local.base_name}-routing-http"
      rule_type                  = "Basic"
      http_listener_name         = "${local.base_name}-listener-http"
      backend_address_pool_name  = "${local.base_name}-backendpool"
      backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
    },
    # {
    #   name                       = "${local.base_name}-routing-https"
    #   rule_type                  = "Basic"
    #   http_listener_name         = "${local.base_name}-listener-https"
    #   backend_address_pool_name  = "${local.base_name}-backendpool"
    #   backend_http_settings_name = "${local.base_name}-backhttpsettings-https"
    # }
  ]

  frontend_ip_configuration_custom_name = "${local.base_name}-frontipconfig"

  http_listeners = [
    {
      name                           = "${local.base_name}-listener-http"
      frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
      frontend_port_name             = "frontend-http-port"
      protocol                       = "Http"
      host_name                      = "example.com"
    },
    # {
    #   name                           = "${local.base_name}-listener-https"
    #   frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
    #   frontend_port_name             = "frontend-https-port"
    #   protocol                       = "Https"
    #   ssl_certificate_name           = "${local.base_name}-example-com-sslcert"
    #   require_sni                    = true
    #   host_name                      = "example.com"
    # }
  ]

  frontend_ports = [{
    name = "frontend-http-port"
    port = 80
  }]

  #  ssl_certificates = [{
  #    name     = "${local.base_name}-example-com-sslcert"
  #    data     = var.certificate_example_com_filebase64
  #    password = var.certificate_example_com_password
  #  }]

  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  rewrite_rule_sets = [{
    name = "${local.base_name}-example-rewrite-rule-set"
    rewrite_rules = [
      {
        name          = "${local.base_name}-example-rewrite-rule-response-header"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = true
            negate      = false
            pattern     = "text/html(.*)"
            variable    = "http_resp_Content-Type"
          }
        ]
        response_header_configurations = [{
          header_name  = "X-Frame-Options"
          header_value = "DENY"
        }]
      },
      {
        name          = "${local.base_name}-example-rewrite-rule-url"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = false
            negate      = false
            pattern     = ".*-R[0-9]{10,10}\\.html"
            variable    = "var_uri_path"
          },
          {
            ignore_case = true
            negate      = false
            pattern     = ".*\\.fr"
            variable    = "var_host"
          }
        ]
        url_reroute = {
          path         = "/fr{var_uri_path}"
          query_string = null
          reroute      = false
        }
      }
    ]
  }]

  url_path_maps = [
    {
      name                               = "${local.base_name}-example-url-path-map"
      default_backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
      default_backend_address_pool_name  = "${local.base_name}-backendpool"
      default_rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
      # default_redirect_configuration_name = "${local.base_name}-redirect"
      path_rules = [
        {
          name                       = "${local.base_name}-example-url-path-rule"
          backend_address_pool_name  = "${local.base_name}-backendpool"
          backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
          rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
          paths                      = ["/demo/"]
        }
      ]
    }
  ]

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 15
  }

  logs_destinations_ids = [
    # module.logs.id,
    # module.logs.storage_account_id,
  ]
}
