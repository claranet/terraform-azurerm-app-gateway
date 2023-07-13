module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "~> 3.0"

  for_each = local.subnet_names

  environment        = var.environment
  location_short     = var.location_short
  client_name        = var.client_name
  stack              = var.stack
  custom_subnet_name = each.key

  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  subnet_cidr_list     = [each.value]

  network_security_group_id = module.network_security_group.network_security_group_id
}
