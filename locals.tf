locals {
  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  appgw_name = var.appgw_name != "" ? var.appgw_name : join("-", [local.default_name, "appgw"])

  subnet_name = var.custom_subnet_name != "" ? [var.custom_subnet_name] : [join("-", [local.default_name, "subnet"])]
  subnet_id   = var.create_subnet ? module.azure-network-subnet.subnet_ids[0] : var.subnet_id

  nsg_ids = var.create_nsg ? {
    element(local.subnet_name, 0) = join("", module.azure-network-security-group.network_security_group_id)
  } : {}

  nsr_https_name       = coalesce(var.custom_nsr_https_name, join("-", [local.default_name, "https-nsr"]))
  nsr_healthcheck_name = coalesce(var.custom_nsr_healthcheck_name, join("-", [local.default_name, "appgw-healthcheck-nsr"]))

  ip_name  = var.ip_name != "" ? var.ip_name : join("-", [local.default_name, "pubip"])
  ip_label = var.ip_label != "" ? var.ip_label : join("-", [local.default_name, "pubip"])

  frontend_ip_configuration_name      = var.frontend_ip_configuration_name != "" ? var.frontend_ip_configuration_name : join("-", [local.default_name, "frontipconfig"])
  frontend_priv_ip_configuration_name = var.frontend_priv_ip_configuration_name != "" ? var.frontend_ip_configuration_name : join("-", [local.default_name, "frontipconfig-priv"])

  gateway_ip_configuration_name = var.gateway_ip_configuration_name != "" ? var.gateway_ip_configuration_name : join("-", [local.default_name, "gwipconfig"])

  diag_settings_name = var.diag_settings_name != "" ? var.diag_settings_name : join("-", [local.default_name, "diag-settings"])

  enable_waf = var.sku == "WAF_v2" ? true : false

  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  # https://docs.microsoft.com/fr-fr/azure/api-management/api-management-howto-integrate-internal-vnet-appgateway#exposing-the-developer-portal-externally-through-application-gateway
  disabled_rule_group_settings_dev_portal = [
    {
      rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
      rules = [
        942100,
        942200,
        942110,
        942180,
        942260,
        942340,
        942370,
        942430,
        942440
      ]
    },
    {
      rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
      rules = [
        920300,
        920330
      ]
    },
    {
      rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
      rules = [
        931130
      ]
    }
  ]

  disabled_rule_group_settings = var.disable_waf_rules_for_dev_portal ? concat(local.disabled_rule_group_settings_dev_portal, var.disabled_rule_group_settings) : var.disabled_rule_group_settings
}
