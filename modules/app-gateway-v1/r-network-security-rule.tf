resource "azurerm_network_security_rule" "allow_web" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_web_application_gateway"
  network_security_group_name = module.network-security-group.network_security_group_name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  description                 = "Allow access from frontend_port of appgw"

  source_port_range = "*"

  source_address_prefix = "Internet"

  destination_port_ranges    = local.frontend_port
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "allow_health_probe_app_gateway" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "allow_health_probe_application_gateway"
  network_security_group_name = module.network-security-group.network_security_group_name
  priority                    = 101
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  description                 = "Allow health probe access from internet"

  source_port_range     = "*"
  source_address_prefix = "Internet"

  destination_port_ranges    = ["65503-65534"]
  destination_address_prefix = "*"
}
