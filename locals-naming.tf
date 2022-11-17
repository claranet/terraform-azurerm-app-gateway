locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  appgw_name  = coalesce(var.custom_appgw_name, data.azurecaf_name.appgw.result)
  subnet_name = coalesce(var.custom_subnet_name, data.azurecaf_name.subnet_appgw.result)
  nsg_name    = coalesce(var.custom_nsg_name, data.azurecaf_name.nsg_appgw.result)

  ip_name  = coalesce(var.custom_ip_name, data.azurecaf_name.pip_appgw.result)
  ip_label = coalesce(var.custom_ip_label, data.azurecaf_name.pip_appgw.result)

  nsr_https_name       = coalesce(var.custom_nsr_https_name, data.azurecaf_name.nsr_https.result)
  nsr_healthcheck_name = coalesce(var.custom_nsr_healthcheck_name, data.azurecaf_name.nsr_healthcheck.result)

  frontend_ip_configuration_name      = coalesce(var.custom_frontend_ip_configuration_name, data.azurecaf_name.frontipconfig.result)
  frontend_priv_ip_configuration_name = coalesce(var.custom_frontend_priv_ip_configuration_name, data.azurecaf_name.frontipconfig_priv.result)

  gateway_ip_configuration_name = coalesce(var.custom_gateway_ip_configuration_name, data.azurecaf_name.gwipconfig.result)
}
