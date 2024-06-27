data "azurecaf_name" "appgw" {
  name          = var.stack
  resource_type = "azurerm_application_gateway"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "subnet_appgw" {
  name          = var.stack
  resource_type = "azurerm_subnet"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "nsg_appgw" {
  name          = var.stack
  resource_type = "azurerm_network_security_group"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "pip_appgw" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "nsr_https" {
  name          = var.stack
  resource_type = "azurerm_network_security_group_rule"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, "https"])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "nsr_healthcheck" {
  name          = var.stack
  resource_type = "azurerm_network_security_group_rule"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, "appgw-healthcheck"])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "frontipconfig" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "frontipconfig_priv" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "gwipconfig" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
