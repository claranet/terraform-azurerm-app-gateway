output "appgw_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.app_gateway.id
}

output "appgw_name" {
  description = "The name of the Application Gateway."
  value       = local.appgw_name
}

output "appgw_subnet_id" {
  description = "The ID of the subnet where the Application Gateway is attached."
  value       = var.create_subnet == true ? join("", module.azure-network-subnet.subnet_ids) : var.subnet_id
}

output "appgw_subnet_name" {
  description = "The name of the subnet where the Application Gateway is attached."
  value       = var.create_subnet == true ? join("", module.azure-network-subnet.subnet_names) : null
}

output "appgw_nsg_id" {
  description = "The ID of the network security group from the subnet where the Application Gateway is attached."
  value       = module.azure-network-security-group.network_security_group_id
}

output "appgw_nsg_name" {
  description = "The name of the network security group from the subnet where the Application Gateway is attached."
  value       = module.azure-network-security-group.network_security_group_name
}

output "appgw_public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.ip.ip_address
}

output "appgw_backend_address_pool_ids" {
  description = "List of backend address pool Ids."
  value       = azurerm_application_gateway.app_gateway.backend_address_pool.*.id
}

output "appgw_backend_http_settings_ids" {
  description = "List of backend HTTP settings Ids."
  value       = azurerm_application_gateway.app_gateway.backend_http_settings.*.id
}

output "appgw_backend_http_settings_probe_ids" {
  description = "List of probe Ids from backend HTTP settings."
  value       = azurerm_application_gateway.app_gateway.backend_http_settings.*.probe_id
}

output "appgw_frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration Ids."
  value       = azurerm_application_gateway.app_gateway.frontend_ip_configuration.*.id
}

output "appgw_frontend_port_ids" {
  description = "List of frontend port Ids."
  value       = azurerm_application_gateway.app_gateway.frontend_port.*.id
}

output "appgw_gateway_ip_configuration_ids" {
  description = "List of IP configuration Ids."
  value       = azurerm_application_gateway.app_gateway.gateway_ip_configuration.*.id
}

output "appgw_http_listener_ids" {
  description = "List of HTTP listener Ids."
  value       = azurerm_application_gateway.app_gateway.http_listener.*.id
}

output "appgw_http_listener_frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration Ids from HTTP listeners."
  value       = azurerm_application_gateway.app_gateway.http_listener.*.frontend_ip_configuration_id
}

output "appgw_http_listener_frontend_port_ids" {
  description = "List of frontend port Ids from HTTP listeners."
  value       = azurerm_application_gateway.app_gateway.http_listener.*.frontend_port_id
}

output "appgw_request_routing_rule_ids" {
  description = "List of request routing rules Ids."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.id
}

output "appgw_request_routing_rule_http_listener_ids" {
  description = "List of HTTP listener Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.http_listener_id
}

output "appgw_request_routing_rule_backend_address_pool_ids" {
  description = "List of backend address pool Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.backend_address_pool_id
}

output "appgw_request_routing_rule_backend_http_settings_ids" {
  description = "List of HTTP settings Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.backend_http_settings_id
}

output "appgw_request_routing_rule_redirect_configuration_ids" {
  description = "List of redirect configuration Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.redirect_configuration_id
}

output "appgw_request_routing_rule_rewrite_rule_set_ids" {
  description = "List of rewrite rule set Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.rewrite_rule_set_id
}

output "appgw_request_routing_rule_url_path_map_ids" {
  description = "List of URL path map Ids attached to request routing rules."
  value       = azurerm_application_gateway.app_gateway.request_routing_rule.*.url_path_map_id
}

output "appgw_ssl_certificate_ids" {
  description = "List of SSL certificate Ids."
  value       = azurerm_application_gateway.app_gateway.ssl_certificate.*.id
}

output "appgw_url_path_map_ids" {
  description = "List of URL path map Ids."
  value       = azurerm_application_gateway.app_gateway.url_path_map.*.id
}

output "appgw_url_path_map_default_backend_address_pool_ids" {
  description = "List of default backend address pool Ids attached to URL path maps."
  value       = azurerm_application_gateway.app_gateway.url_path_map.*.default_backend_address_pool_id
}

output "appgw_url_path_map_default_backend_http_settings_ids" {
  description = "List of default backend HTTP settings Ids attached to URL path maps."
  value       = azurerm_application_gateway.app_gateway.url_path_map.*.default_backend_http_settings_id
}

output "appgw_url_path_map_default_redirect_configuration_ids" {
  description = "List of default redirect configuration Ids attached to URL path maps."
  value       = azurerm_application_gateway.app_gateway.url_path_map.*.default_redirect_configuration_id
}

output "appgw_custom_error_configuration_ids" {
  description = "List of custom error configuration Ids."
  value       = azurerm_application_gateway.app_gateway.custom_error_configuration.*.id
}

output "appgw_redirect_configuration_ids" {
  description = "List of redirect configuration Ids."
  value       = azurerm_application_gateway.app_gateway.redirect_configuration.*.id
}
