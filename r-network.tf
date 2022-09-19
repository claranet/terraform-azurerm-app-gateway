module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "6.0.0"

  for_each = var.create_subnet ? toset(["appgw_subnet"]) : []

  environment         = var.environment
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)

  virtual_network_name = var.virtual_network_name

  custom_subnet_name = local.subnet_name
  subnet_cidr_list   = [var.subnet_cidr]

  network_security_group_name = local.nsg_name

  route_table_name = var.route_table_name
  route_table_rg   = var.route_table_rg
}

module "azure_network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "6.0.1"

  for_each = var.create_nsg ? toset(["appgw_nsg"]) : []

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  custom_network_security_group_name = var.custom_nsg_name

  deny_all_inbound = false

  default_tags_enabled = false # already merged in locals-tags.tf

  # Flow Logs
  flow_log_enabled                               = var.flow_log_enabled
  flow_log_logging_enabled                       = var.flow_log_logging_enabled
  network_watcher_name                           = var.network_watcher_name
  network_watcher_resource_group_name            = var.network_watcher_resource_group_name
  flow_log_storage_account_id                    = var.flow_log_storage_account_id
  flow_log_retention_policy_enabled              = var.flow_log_retention_policy_enabled
  flow_log_retention_policy_days                 = var.flow_log_retention_policy_days
  flow_log_traffic_analytics_enabled             = var.flow_log_traffic_analytics_enabled
  log_analytics_workspace_guid                   = var.log_analytics_workspace_guid
  log_analytics_workspace_location               = var.log_analytics_workspace_location
  log_analytics_workspace_id                     = var.log_analytics_workspace_id
  flow_log_traffic_analytics_interval_in_minutes = var.flow_log_traffic_analytics_interval_in_minutes
  flow_log_location                              = var.flow_log_location

  extra_tags = local.nsg_tags
}

resource "azurerm_network_security_rule" "web" {
  count = var.create_nsg && var.create_nsg_https_rule ? 1 : 0

  name = local.nsr_https_name

  resource_group_name         = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  network_security_group_name = module.azure_network_security_group["appgw_nsg"].network_security_group_name

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
  network_security_group_name = module.azure_network_security_group["appgw_nsg"].network_security_group_name

  priority  = 101
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range       = "*"
  destination_port_ranges = ["65200-65535"]

  source_address_prefix      = "Internet"
  destination_address_prefix = "*"
}
