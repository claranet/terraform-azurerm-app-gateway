locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  appgw_name = var.appgw_name != "" ? var.appgw_name : join("-", [local.default_name, "appgw"])

  subnet_name = var.custom_subnet_name != "" ? [var.custom_subnet_name] : [join("-", [local.default_name, "subnet"])]
  subnet_cidr = var.custom_subnet_cidr != "" ? [var.custom_subnet_cidr] : ["192.168.0.0/24"]

  nsg_https_name = coalesce(var.custom_nsg_https_name, join("-", [local.default_name, "-https-nsr"]))

  ip_name  = var.ip_name != "" ? var.ip_name : join("-", [local.default_name, "pubip"])
  ip_label = var.ip_label != "" ? var.ip_label : join("-", [local.default_name, "pubip"])

  frontend_ip_configuration_name = var.frontend_ip_configuration_name != "" ? var.frontend_ip_configuration_name : join("-", [local.default_name, "frontipconfig"])

  gateway_ip_configuration_name = var.gateway_ip_configuration_name != "" ? var.gateway_ip_configuration_name : join("-", [local.default_name, "gwipconfig"])

  diag_settings_name = var.diag_settings_name != "" ? var.diag_settings_name : join("-", [local.default_name, "diag-settings"])

  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}
