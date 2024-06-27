output "id" {
  description = "Application Gateway ID."
  value       = azurerm_application_gateway.main.id
}

output "name" {
  description = "Application Gateway name."
  value       = azurerm_application_gateway.main.name
}

output "resource" {
  description = "Application Gateway resource object."
  value       = azurerm_application_gateway.main
}

output "module_subnet" {
  description = "Subnet module object."
  value       = one(module.subnet[*])
}

output "module_nsg" {
  description = "Network Security Group module object."
  value       = one(module.nsg[*])
}

output "resource_public_ip" {
  description = "Public IP resource object."
  value       = azurerm_public_ip.main
}

output "subnet_id" {
  description = "The ID of the subnet where the Application Gateway is attached."
  value       = coalesce(one(module.subnet[*].id), var.subnet_id)
}

output "subnet_name" {
  description = "The name of the subnet where the Application Gateway is attached."
  value       = coalesce(one(module.subnet[*].name), reverse(split("/", var.subnet_id))[0])
}

output "nsg_id" {
  description = "The ID of the network security group from the subnet where the Application Gateway is attached."
  value       = var.create_nsg == true ? one(module.nsg[*].id) : null
}

output "nsg_name" {
  description = "The name of the network security group from the subnet where the Application Gateway is attached."
  value       = var.create_nsg == true ? one(module.nsg[*].name) : null
}

output "public_ip_address" {
  description = "The public IP address of Application Gateway."
  value       = azurerm_public_ip.main.ip_address
}

output "public_ip_fqdn" {
  description = "Fully qualified domain name of the A DNS record associated with the public IP."
  value       = azurerm_public_ip.main.fqdn
}

output "public_ip_domain_name" {
  description = "Domain Name part from FQDN of the A DNS record associated with the public IP."
  value       = azurerm_public_ip.main.domain_name_label
}

output "backend_address_pool_ids" {
  description = "List of backend address pool IDs."
  value       = azurerm_application_gateway.main.backend_address_pool[*].id
}

output "backend_http_settings_ids" {
  description = "List of backend HTTP settings IDs."
  value       = azurerm_application_gateway.main.backend_http_settings[*].id
}

output "backend_http_settings_probe_ids" {
  description = "List of probe IDs from backend HTTP settings."
  value       = azurerm_application_gateway.main.backend_http_settings[*].probe_id
}

output "frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration IDs."
  value       = azurerm_application_gateway.main.frontend_ip_configuration[*].id
}

output "frontend_port_ids" {
  description = "List of frontend port IDs."
  value       = azurerm_application_gateway.main.frontend_port[*].id
}

output "gateway_ip_configuration_ids" {
  description = "List of IP configuration IDs."
  value       = azurerm_application_gateway.main.gateway_ip_configuration[*].id
}

output "http_listener_ids" {
  description = "List of HTTP listener IDs."
  value       = azurerm_application_gateway.main.http_listener[*].id
}

output "http_listener_frontend_ip_configuration_ids" {
  description = "List of frontend IP configuration IDs from HTTP listeners."
  value       = azurerm_application_gateway.main.http_listener[*].frontend_ip_configuration_id
}

output "http_listener_frontend_port_ids" {
  description = "List of frontend port IDs from HTTP listeners."
  value       = azurerm_application_gateway.main.http_listener[*].frontend_port_id
}

output "request_routing_rule_ids" {
  description = "List of request routing rules IDs."
  value       = azurerm_application_gateway.main.request_routing_rule[*].id
}

output "request_routing_rule_http_listener_ids" {
  description = "List of HTTP listener ICs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].http_listener_id
}

output "request_routing_rule_backend_address_pool_ids" {
  description = "List of backend address pool IDs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].backend_address_pool_id
}

output "request_routing_rule_backend_http_settings_ids" {
  description = "List of HTTP settings IDs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].backend_http_settings_id
}

output "request_routing_rule_redirect_configuration_ids" {
  description = "List of redirect configuration IDs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].redirect_configuration_id
}

output "request_routing_rule_rewrite_rule_set_ids" {
  description = "List of rewrite rule set IDs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].rewrite_rule_set_id
}

output "request_routing_rule_url_path_map_ids" {
  description = "List of URL path map IDs attached to request routing rules."
  value       = azurerm_application_gateway.main.request_routing_rule[*].url_path_map_id
}

output "ssl_certificate_ids" {
  description = "List of SSL certificate IDs."
  value       = azurerm_application_gateway.main.ssl_certificate[*].id
  sensitive   = true
}

output "url_path_map_ids" {
  description = "List of URL path map IDs."
  value       = azurerm_application_gateway.main.url_path_map[*].id
}

output "url_path_map_default_backend_address_pool_ids" {
  description = "List of default backend address pool IDs attached to URL path maps."
  value       = azurerm_application_gateway.main.url_path_map[*].default_backend_address_pool_id
}

output "url_path_map_default_backend_http_settings_ids" {
  description = "List of default backend HTTP settings IDs attached to URL path maps."
  value       = azurerm_application_gateway.main.url_path_map[*].default_backend_http_settings_id
}

output "url_path_map_default_redirect_configuration_ids" {
  description = "List of default redirect configuration IDs attached to URL path maps."
  value       = azurerm_application_gateway.main.url_path_map[*].default_redirect_configuration_id
}

output "custom_error_configuration_ids" {
  description = "List of custom error configuration IDs."
  value       = azurerm_application_gateway.main.custom_error_configuration[*].id
}

output "redirect_configuration_ids" {
  description = "List of redirect configuration IDs."
  value       = azurerm_application_gateway.main.redirect_configuration[*].id
}
