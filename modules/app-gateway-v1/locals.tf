locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  # Application Gateway locals

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  application_gateway_name = coalesce(
    var.custom_appgw_name,
    format("%s%s-%s-%s-%s-appgw", local.name_prefix, var.stack, var.client_name, var.location_short, var.environment),
  )

  gateway_ip_configuration_name  = format("%s-gwip", local.application_gateway_name)
  frontend_ip_configuration_name = format("%s-feip", local.application_gateway_name)
  frontend_port_name             = format("%s-feport", local.application_gateway_name)
  backend_address_pool_name      = format("%s-beap", local.application_gateway_name)
  http_setting_name              = format("%s-be-htst", local.application_gateway_name)
  listener_name                  = format("%s-httplstn", local.application_gateway_name)
  url_path_map_name              = format("%s-upm", local.application_gateway_name)
  request_routing_rule_name      = format("%s-rqrt", local.application_gateway_name)
  redirect_configuration_name    = format("%s-rdrcfg", local.application_gateway_name)

  ## Frontend port local
  frontend_port = coalescelist(var.frontend_port, [443])

  # Network locals

  public_ip_name = coalesce(
    var.custom_ippub_name,
    format("%s%s-%s-%s-%s-pubip", local.name_prefix, var.stack, var.client_name, var.location_short, var.environment),
  )

  subnet_name = format("%s-%s-%s-%s-appgw-subnet", var.stack, var.client_name, var.location_short, var.environment)
}
