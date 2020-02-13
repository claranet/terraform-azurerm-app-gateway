locals {
  default_name = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"

  appgw_name = var.appgw_name != "" ? var.appgw_name : join("-", [local.default_name, "appgw"])

  vnet_cidr = var.custom_vnet_cidr != "" ? [var.custom_vnet_cidr] : ["192.168.0.0/16"]

  subnet_name = var.custom_subnet_name != "" ? [var.custom_subnet_name] : [join("-", [local.default_name, "subnet"])]
  subnet_cidr = var.custom_subnet_cidr != "" ? [var.custom_subnet_cidr] : ["192.168.0.0/24"]

  nsg_https_name = coalesce(var.custom_nsg_https_name, join("-", [local.default_name, "-https-nsr"]))

  ip_name  = var.ip_name != "" ? var.ip_name : join("-", [local.default_name, "pubip"])
  ip_label = var.ip_label != "" ? var.ip_label : join("-", [local.default_name, "pubip"])

  frontend_ip_configuration_name = var.frontend_ip_configuration_name != "" ? var.frontend_ip_configuration_name : join("-", [local.default_name, "frontipconfig"])

  gateway_ip_configuration_name = var.gateway_ip_configuration_name != "" ? var.gateway_ip_configuration_name : join("-", [local.default_name, "gwipconfig"])

  default_tags = {
    env   = var.environment
    stack = var.stack
  }
}
