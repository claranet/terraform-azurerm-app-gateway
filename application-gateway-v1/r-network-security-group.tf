module "network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "2.0.1"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  # You can set either a prefix for generated name or a custom one for the resource naming
  custom_name = var.custom_security_group_name
}
