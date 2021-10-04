resource "azurecaf_name" "appgw" {
  name          = var.stack
  resource_type = "azurerm_application_gateway"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "appgw"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "subnet_appgw" {
  name          = var.stack
  resource_type = "azurerm_subnet"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "subnet"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "nsg_appgw" {
  name          = var.stack
  resource_type = "azurerm_network_security_group"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "nsg"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "pip_appgw" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "pubip"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "nsr_https" {
  name          = var.stack
  resource_type = "azurerm_network_security_group_rule"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, "https", var.use_caf_naming ? "" : "nsr"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "nsr_healthcheck" {
  name          = var.stack
  resource_type = "azurerm_network_security_group_rule"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, "appgw-healthcheck", var.use_caf_naming ? "" : "nsr"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "frontipconfig" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = compact([var.use_caf_naming ? "frontipconfig" : "", local.name_prefix])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "frontipconfig"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "frontipconfig_priv" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = compact([var.use_caf_naming ? "frontipconfig-priv" : "", local.name_prefix])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "frontipconfig-priv"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

resource "azurecaf_name" "gwipconfig" {
  name          = var.stack
  resource_type = "azurerm_public_ip"
  prefixes      = compact([var.use_caf_naming ? "gwipconfig" : "", local.name_prefix])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "gwipconfig"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}
