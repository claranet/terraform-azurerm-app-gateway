module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "2.1.0"

  environment         = var.environment
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = var.subnet_resource_group_name != "" ? var.subnet_resource_group_name : var.resource_group_name

  virtual_network_name = var.virtual_network_name

  custom_subnet_names = var.create_subnet == true ? local.subnet_name : []
  subnet_cidr_list    = var.create_subnet == true ? local.subnet_cidr : []

  network_security_group_ids = var.create_subnet == true ? {
    element(local.subnet_name, 0) = module.azure-network-security-group.network_security_group_id
  } : {}

  route_table_ids = var.create_subnet == true ? {} : {}
}


module "azure-network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "2.0.1"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.subnet_resource_group_name != "" ? var.subnet_resource_group_name : var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  extra_tags = merge(local.default_tags, var.extra_tags)

  custom_name = var.custom_nsg_name
}
resource "azurerm_network_security_rule" "web" {
  count = var.create_network_security_rules ? 1 : 0

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
  count = var.create_network_security_rules ? 1 : 0

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
