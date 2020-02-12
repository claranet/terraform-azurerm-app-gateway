module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "2.1.0"

  environment        = var.environment
  location_short     = var.location_short
  client_name        = var.client_name
  stack              = var.stack
  custom_subnet_name = local.subnet_name

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_cidr_list     = var.subnet_cidr_list

  route_table_ids = {}

  network_security_group_ids = {
    local.subnet_name = module.network-security-group.network_security_group_id
  }
}
