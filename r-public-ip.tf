resource "azurerm_public_ip" "ip" {
  location            = var.location
  name                = local.ip_name
  resource_group_name = var.resource_group_name
  ## Default value to "Standard" sku because "Basic" is not compatible
  ## with Application Gateway v2
  sku = var.ip_sku
  ## Default value to "Static" allocation because can't switch to "Dynamic"
  ## with IP sku to "Standard"
  allocation_method = var.ip_allocation_method

  domain_name_label = local.ip_label

  tags = merge(local.default_tags, var.ip_tags)
}
