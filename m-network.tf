resource "terraform_data" "create_subnet_condition" {
  count = var.create_subnet ? 1 : 0

  triggers_replace = {
    vnet_name   = var.virtual_network_name
    subnet_cidr = var.subnet_cidr
  }

  lifecycle {
    precondition {
      condition     = var.virtual_network_name != null || var.subnet_cidr != ""
      error_message = "When `var.create_subnet == true`, `var.virtual_network_name` and `var.subnet_cidr` must not be empty."
    }
  }
}

module "subnet" {
  source  = "claranet/subnet/azurerm"
  version = "~> 8.0.0"

  count = var.create_subnet ? 1 : 0

  environment         = var.environment
  location_short      = var.location_short
  client_name         = var.client_name
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)

  virtual_network_name = var.virtual_network_name

  custom_name = local.subnet_name
  cidrs       = var.subnet_cidr[*]

  network_security_group_name = var.create_nsg ? local.nsg_name : null

  route_table_name = var.route_table_name
  route_table_rg   = var.route_table_rg

  service_endpoints = ["Microsoft.KeyVault"]

  depends_on = [
    terraform_data.create_subnet_condition,
  ]
}

moved {
  from = module.azure_network_subnet["appgw_subnet"]
  to   = module.subnet[0]
}

module "nsg" {
  source  = "claranet/nsg/azurerm"
  version = "~> 8.0.0"

  count = var.create_nsg ? 1 : 0

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)
  location            = var.location
  location_short      = var.location_short

  custom_name = var.nsg_custom_name

  all_inbound_denied = false

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

  additional_rules = concat(
    var.create_nsg && var.create_nsg_healthprobe_rule ? [{
      name = local.nsr_healthcheck_name

      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      priority  = 101

      source_port_range       = "*"
      destination_port_ranges = ["65200-65535"]

      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }] : [],
    var.create_nsg && var.create_nsg_https_rule ? [{
      name = local.nsr_https_name

      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      priority  = 100

      source_port_range      = "*"
      destination_port_range = "443"

      source_address_prefix      = var.nsr_https_source_address_prefix
      destination_address_prefix = "*"
    }] : []
  )
  extra_tags = local.nsg_tags
}

moved {
  from = module.azure_network_security_group["appgw_nsg"]
  to   = module.nsg[0]
}
