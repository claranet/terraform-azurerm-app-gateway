resource "azurerm_public_ip" "ip" {
  location            = var.location
  name                = local.ip_name
  resource_group_name = var.resource_group_name
  ## Forced to "Standard" sku because "Basic" is not compatible
  ## with Application Gateway v2
  sku = "Standard"
  ## Forced to "Static" allocation because can't switch to "Dynamic"
  ## with IP sku to "Standard"
  allocation_method = "Static"

  domain_name_label = local.ip_label

  tags = merge(local.default_tags, var.ip_tags)
}
