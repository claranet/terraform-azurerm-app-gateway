locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  name = coalesce(var.custom_name, data.azurecaf_name.appgw.result)

  subnet_name    = coalesce(var.subnet_custom_name, data.azurecaf_name.subnet_appgw.result)
  subnet_rg_name = coalesce(var.subnet_resource_group_name, var.resource_group_name)

  nsg_name    = coalesce(var.nsg_custom_name, data.azurecaf_name.nsg_appgw.result)
  nsg_rg_name = coalesce(var.nsg_resource_group_name, var.subnet_resource_group_name, var.resource_group_name)

  ip_name  = coalesce(var.public_ip_custom_name, data.azurecaf_name.pip_appgw.result)
  ip_label = coalesce(var.public_ip_label_custom_name, data.azurecaf_name.pip_appgw.result)

  nsr_https_name       = coalesce(var.nsr_https_custom_name, data.azurecaf_name.nsr_https.result)
  nsr_healthcheck_name = coalesce(var.nsr_healthcheck_custom_name, data.azurecaf_name.nsr_healthcheck.result)

  frontend_ip_configuration_name      = coalesce(var.frontend_ip_configuration_custom_name, data.azurecaf_name.frontipconfig.result)
  frontend_priv_ip_configuration_name = coalesce(var.frontend_private_ip_configuration_custom_name, data.azurecaf_name.frontipconfig_priv.result)

  gateway_ip_configuration_name = coalesce(var.gateway_ip_configuration_custom_name, data.azurecaf_name.gwipconfig.result)
}
