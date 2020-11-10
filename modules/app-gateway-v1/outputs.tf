output "app_gateway_id" {
  description = "Application Gateway ID"
  value       = azurerm_application_gateway.app_gateway.id
}

output "network_security_group_id" {
  description = "Network Security Group ID of the subnet where is Application Gateway"
  value       = module.network-security-group.network_security_group_id
}
