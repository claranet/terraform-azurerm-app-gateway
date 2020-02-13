module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "2.0.1"

  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = var.resource_group_name

  custom_vnet_name = var.custom_vnet_name
  vnet_cidr        = local.vnet_cidr
  extra_tags       = merge(local.default_tags, var.extra_tags)
}

module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "2.1.0"

  environment         = var.environment
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = var.resource_group_name

  virtual_network_name = module.azure-network-vnet.virtual_network_name

  custom_subnet_names = local.subnet_name
  subnet_cidr_list    = local.subnet_cidr

  network_security_group_ids = {
    element(local.subnet_name, 0) = module.azure-network-security-group.network_security_group_id
  }

  route_table_ids = {}
}


module "azure-network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "2.0.1"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  extra_tags = merge(local.default_tags, var.extra_tags)

  custom_name = var.custom_nsg_name
}
resource "azurerm_network_security_rule" "web" {
  name = local.nsg_https_name

  resource_group_name         = var.resource_group_name
  network_security_group_name = module.azure-network-security-group.network_security_group_name

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  destination_port_ranges = ["443"]

  source_address_prefix      = "*"
  destination_address_prefix = "*"
}


resource "azurerm_network_security_rule" "allow_health_probe_app_gateway" {
  name = "allow_health_probe_application_gateway"

  resource_group_name         = var.resource_group_name
  network_security_group_name = module.azure-network-security-group.network_security_group_name

  priority  = 101
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  destination_port_ranges = ["65200-65535"]

  source_address_prefix      = "Internet"
  destination_address_prefix = "*"
}
