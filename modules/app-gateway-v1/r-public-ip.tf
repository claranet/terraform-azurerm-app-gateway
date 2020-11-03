resource "azurerm_public_ip" "ip" {
  location            = var.location
  name                = local.public_ip_name
  resource_group_name = var.resource_group_name
  domain_name_label   = var.domain_name_label

  sku               = var.ip_sku
  allocation_method = var.ip_allocation_method

  tags = merge(local.default_tags, var.extra_tags)
}
