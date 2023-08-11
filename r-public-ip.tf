resource "azurerm_public_ip" "ip" {
  name     = local.ip_name
  location = var.location

  resource_group_name = var.resource_group_name

  ## Default value to "Standard" SKU because "Basic" is not compatible with Application Gateway v2
  sku = var.ip_sku

  ## Default value to "Static" as it is not possible to switch to "Dynamic" if the SKU is "Standard"
  allocation_method = var.ip_allocation_method

  domain_name_label = local.ip_label

  ddos_protection_mode    = var.ip_ddos_protection_mode
  ddos_protection_plan_id = var.ip_ddos_protection_plan_id

  ## Public IP should be distributed across same zones as the Application Gateway to avoid this error:
  # Zonal Application Gateway xxx with zones 2, 3, 1 cannot reference a non-zonal public ip
  # The IP should use all zones used by the Application Gateway.
  zones = var.zones

  tags = local.ip_tags
}
