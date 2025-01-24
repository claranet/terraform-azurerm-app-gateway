locals {
  subnet_id = var.create_subnet ? one(module.subnet[*].id) : var.subnet_id

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

  rule_group_settings_enabled = var.waf_rules_for_dev_portal_enabled ? try(var.waf_configuration.disabled_rule_group, []) : concat(local.disabled_rule_group_settings_dev_portal, try(var.waf_configuration.disabled_rule_group, []))
}
