module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "4.2.1"

  for_each = var.create_subnet ? ["_"] : []

  environment         = var.environment
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)

  virtual_network_name = var.virtual_network_name

  custom_subnet_name = local.subnet_name
  subnet_cidr_list   = [var.subnet_cidr]

  network_security_group_ids = local.nsg_ids

  route_table_ids = var.route_table_ids
}

module "azure_network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "4.1.1"

  for_each = var.create_nsg ? ["_"] : []

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  custom_network_security_group_name = var.custom_nsg_name

  extra_tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_network_security_rule" "web" {
  count = var.create_nsg && var.create_nsg_https_rule ? 1 : 0

  name = local.nsr_https_name

  resource_group_name         = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  network_security_group_name = module.azure_network_security_group[0].network_security_group_name

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  destination_port_ranges = ["443"]

  source_address_prefix      = var.nsr_https_source_address_prefix != "*" ? var.nsr_https_source_address_prefix : "*"
  destination_address_prefix = "*"
}


resource "azurerm_network_security_rule" "allow_health_probe_app_gateway" {
  count = var.create_nsg && var.create_nsg_healthprobe_rule ? 1 : 0

  name = local.nsr_healthcheck_name

  resource_group_name         = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  network_security_group_name = module.azure_network_security_group[0].network_security_group_name

  priority  = 101
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  destination_port_ranges = ["65200-65535"]

  source_address_prefix      = "Internet"
  destination_address_prefix = "*"
}
