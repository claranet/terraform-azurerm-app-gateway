resource "azurerm_public_ip" "main" {
  name     = local.ip_name
  location = var.location

  resource_group_name = var.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"

  domain_name_label = local.ip_label

  ddos_protection_mode    = var.public_ip.ddos_protection_mode
  ddos_protection_plan_id = var.public_ip.ddos_protection_plan_id

  ## Public IP should be distributed across same zones as the Application Gateway to avoid this error:
  # Zonal Application Gateway xxx with zones 2, 3, 1 cannot reference a non-zonal public ip
  # The IP should use all zones used by the Application Gateway.
  zones = var.zones

  tags = local.ip_tags
}

moved {
  from = azurerm_public_ip.ip
  to   = azurerm_public_ip.main
}
