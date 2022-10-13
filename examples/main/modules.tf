module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "run_common" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  tenant_id = var.azure_tenant_id

  monitoring_function_splunk_token = null
}

module "azure_virtual_network" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  vnet_cidr = ["192.168.0.0/16"]
}

locals {
  base_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}"
}

module "appgw_v2" {
  source  = "claranet/app-gateway/azurerm"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_virtual_network.virtual_network_name
  subnet_cidr          = "192.168.1.0/24"

  appgw_backend_http_settings = [{
    name                  = "${local.base_name}-backhttpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 300
  }]

  appgw_backend_pools = [{
    name  = "${local.base_name}-backendpool"
    fqdns = ["example.com"]
  }]

  appgw_routings = [{
    name                       = "${local.base_name}-routing-https"
    rule_type                  = "Basic"
    http_listener_name         = "${local.base_name}-listener-https"
    backend_address_pool_name  = "${local.base_name}-backendpool"
    backend_http_settings_name = "${local.base_name}-backhttpsettings"
  }]

  custom_frontend_ip_configuration_name = "${local.base_name}-frontipconfig"

  appgw_http_listeners = [{
    name                           = "${local.base_name}-listener-https"
    frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
    frontend_port_name             = "frontend-https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "${local.base_name}-example-com-sslcert"
    require_sni                    = true
    host_name                      = "example.com"
    # custom_error_configuration = {
    #   custom1 = {
    #     custom_error_page_url = "https://example.com/custom_error_403_page.html"
    #     status_code           = "HttpStatus403"
    #   },
    #   custom2 = {
    #     custom_error_page_url = "https://example.com/custom_error_502_page.html"
    #     status_code           = "HttpStatus502"
    #   }
    # }
  }]

  # custom_error_configuration = [
  #   {
  #     custom_error_page_url = "https://example.com/custom_error_403_page.html"
  #     status_code           = "HttpStatus403"
  #   },
  #   {
  #     custom_error_page_url = "https://example.com/custom_error_502_page.html"
  #     status_code           = "HttpStatus502"
  #   }
  # ]

  frontend_port_settings = [{
    name = "frontend-https-port"
    port = 443
  }]

  ssl_certificates_configs = [{
    name     = "${local.base_name}-example-com-sslcert"
    data     = var.certificate_example_com_filebase64
    password = var.certificate_example_com_password
  }]

  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  appgw_rewrite_rule_set = [{
    name = "${local.base_name}-example-rewrite-rule-set"
    rewrite_rule = [
      {
        name          = "${local.base_name}-example-rewrite-rule-response-header"
        rule_sequence = 100
        condition = [
          {
            condition_ignore_case = true
            condition_negate      = false
            condition_pattern     = "text/html(.*)"
            condition_variable    = "http_resp_Content-Type"
          }
        ]
        response_header_name  = "X-Frame-Options"
        response_header_value = "DENY"
      },
      {
        name          = "${local.base_name}-example-rewrite-rule-url"
        rule_sequence = 100
        condition = [
          {
            condition_ignore_case = false
            condition_negate      = false
            condition_pattern     = ".*-R[0-9]{10,10}\\.html"
            condition_variable    = "var_uri_path"
          },
          {
            condition_ignore_case = true
            condition_negate      = false
            condition_pattern     = ".*\\.fr"
            condition_variable    = "var_host"
          }
        ]
        url_path     = "/fr{var_uri_path}"
        query_string = null
        url_reroute  = false
      }
    ]
  }]

  # appgw_redirect_configuration = [{
  #   name = "${local.base_name}-redirect"
  # }]

  appgw_url_path_map = [{
    name                               = "${local.base_name}-example-url-path-map"
    default_backend_http_settings_name = "${local.base_name}-backhttpsettings"
    default_backend_address_pool_name  = "${local.base_name}-backendpool"
    default_rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
    # default_redirect_configuration_name = "${local.base_name}-redirect"
    path_rule = [
      {
        path_rule_name             = "${local.base_name}-example-url-path-rule"
        backend_address_pool_name  = "${local.base_name}-backendpool"
        backend_http_settings_name = "${local.base_name}-backhttpsettings"
        rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
        paths                      = ["/demo/"]
      }
    ]
  }]

  autoscaling_parameters = {
    min_capacity = 2
    max_capacity = 15
  }

  logs_destinations_ids = [
    module.run_common.log_analytics_workspace_id,
    module.run_common.logs_storage_account_id,
  ]
}
