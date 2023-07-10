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

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
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

module "appgw_v1" {
  source  = "claranet/app-gateway/azurerm//modules/app-gateway-v1"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_virtual_network.virtual_network_name
  subnet_cidr_list     = ["10.10.0.0/24"]

  sku {
    name     = "Standard_Large"
    tier     = "Standard"
    capacity = "2"
  }

  appgw_http_listeners {
    name                 = "contoso_listener"
    port                 = 443
    host_name            = "the.test.com"
    protocol             = "Https"
    ssl_certificate_name = "cert_the_test_com.p12"
  }

  appgw_backend_pools {
    name  = "contoso_backend"
    fqdns = ["url.backend.target"]
  }

  appgw_backend_http_settings {
    name     = "contoso_backend_http_settings"
    port     = 443
    protocol = "Https"
  }
}
