# Azure Application Gateway
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/application-gateway/azurerm/)

This Terraform module creates an [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) associated with a [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm#public-ip-addresses) and with a complete netwotk stack : virtual network, subnet, network security group. The [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-diagnostics#diagnostic-logging) are activated.

## Requirements
 
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.40

## Terraform version compatibility

| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location     = module.azure-region.location
  client_name  = var.client_name
  environment  = var.environment
  stack        = var.stack
}

module "run-common" {
  source = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  tenant_id = var.azure_tenant_id
}


module "appgw_v2" {
  source = "claranet/app-gateway/azurerm"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.resource_group_name

  appgw_backend_http_settings = [{
    name                  = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-backhttpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 300
  }]

  appgw_backend_pools = [{
    name  = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-backendpool"
    fqdns = ["example.com"]
  }]

  appgw_routings = [{
    name                       = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-routing-https"
    rule_type                  = "Basic"
    http_listener_name         = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-listener-https"
    backend_address_pool_name  = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-backendpool"
    backend_http_settings_name = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-backhttpsettings"
  }]

  appgw_http_listeners = [{
    name                           = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-listener-https"
    frontend_ip_configuration_name = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-frontipconfig"
    frontend_port_name             = "frontend-https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-example-com-sslcert"
    host_name                      = "example.com"
    require_sni                    = true
  }]

  frontend_port_settings = [{
    name = "frontend-https-port"
    port = 443
  }]

  ssl_certificates_configs = [{
    name     = "${var.stack}-${var.client_name}-${var.location_short}-${var.environment}-example-com-sslcert"
    data     = "./example.com.pfx"
    password = var.certificate_example_com_password
  }]

  logs_log_analytics_workspace_id = module.run-common.log_analytics_workspace_id
  logs_storage_account_id         = module.run-common.logs_storage_account_id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| app\_gateway\_subnet\_id | Application Gateway subnet ID. | `string` | n/a | yes |
| app\_gateway\_tags | Application Gateway tags. | `map(string)` | `{}` | no |
| appgw\_backend\_http\_settings | List of maps including backend http settings configurations | `any` | n/a | yes |
| appgw\_backend\_pools | List of maps including backend pool configurations | `any` | n/a | yes |
| appgw\_http\_listeners | List of maps including http listeners configurations | `list(map(string))` | n/a | yes |
| appgw\_name | Application Gateway name. | `string` | `""` | no |
| appgw\_probes | List of maps including request probes configurations | `any` | `[]` | no |
| appgw\_redirect\_configuration | List of maps including redirect configurations | `list(map(string))` | `[]` | no |
| appgw\_rewrite\_rule\_set | List of rewrite rule set including rewrite rules | `any` | `[]` | no |
| appgw\_routings | List of maps including request routing rules configurations | `list(map(string))` | `[]` | no |
| appgw\_url\_path\_map | List of maps including url path map configurations | `any` | `[]` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| create\_subnet | Boolean to create subnet with this module. | `bool` | `true` | no |
| create\_vnet | Boolean to create virtual network with this module. | `bool` | `true` | no |
| custom\_nsg\_https\_name | Custom name for the network security group for HTTPS protocol. | `string` | n/a | yes |
| custom\_nsg\_name | Custom name for the network security group. | `string` | n/a | yes |
| custom\_subnet\_cidr | Custom CIDR for the subnet. | `string` | `""` | no |
| custom\_subnet\_name | Custom name for the subnet. | `string` | `""` | no |
| custom\_vnet\_cidr | Custom CIDR for the virtual network. | `string` | `""` | no |
| custom\_vnet\_name | Custom name for the virtual network. | `string` | n/a | yes |
| disabled\_rule\_group\_settings | The rule group where specific rules should be disabled. Accepted values can be found here: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#rule_group_name | <pre>list(object({<br>    rule_group_name = string<br>    rules           = list(string)<br>  }))</pre> | `[]` | no |
| enable\_logging | Boolean flag to specify whether logging is enabled | `bool` | `true` | no |
| enabled\_waf | Boolean to enable WAF. | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| file\_upload\_limit\_mb | The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB. | `number` | `100` | no |
| frontend\_ip\_configuration\_name | The Name of the Frontend IP Configuration used for this HTTP Listener. | `string` | `""` | no |
| frontend\_port\_settings | Frontend port settings. Each port setting contains the name and the port for the frontend port. | `list(map(string))` | `[]` | no |
| gateway\_ip\_configuration\_name | The Name of the Application Gateway IP Configuration. | `string` | `""` | no |
| ip\_label | Domain name label for public IP. | `string` | `""` | no |
| ip\_name | Public IP name. | `string` | `""` | no |
| ip\_tags | Public IP tags. | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_log\_analytics\_workspace\_id | Log Analytics Workspace id for logs | `string` | n/a | yes |
| logs\_storage\_account\_id | Storage Account id for logs | `string` | n/a | yes |
| logs\_storage\_retention | Retention in days for logs on Storage Account | `string` | `"30"` | no |
| max\_request\_body\_size\_kb | The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. | `number` | `128` | no |
| name\_prefix | Optional prefix for the generated name | `string` | n/a | yes |
| policy\_name | Policy name to apply to the WAF configuration. The list of available policies can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview#predefined-ssl-policy | `string` | `"AppGwSslPolicy20170401S"` | no |
| request\_body\_check | Is Request Body Inspection enabled? | `bool` | `true` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| rule\_set\_type | The Type of the Rule Set used for this Web Application Firewall. | `string` | `"OWASP"` | no |
| rule\_set\_version | The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1. | `number` | `3.1` | no |
| sku\_capacity | The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale\_configuration is set | `number` | `2` | no |
| sku\_name | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2. | `string` | `"WAF_v2"` | no |
| sku\_tier | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2. | `string` | `"WAF_v2"` | no |
| ssl\_certificates\_configs | List of maps including ssl certificates configurations | `list(map(string))` | `[]` | no |
| stack | Project stack name | `string` | n/a | yes |
| trusted\_root\_certificate\_configs | List of trusted root certificates. The needed values for each trusted root certificates are 'name' and 'data'. | `list(map(string))` | `[]` | no |
| waf\_exclusion\_settings | WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#match_variable | `list(map(string))` | `[]` | no |
| waf\_mode | The Web Application Firewall Mode. Possible values are Detection and Prevention. | `string` | `"Prevention"` | no |
| zones | A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Application Gateway. |

## Related documentation

Terraform resource documentation: [www.terraform.io/docs/providers/azurerm/r/application_gateway.html](https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/application-gateway/overview](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
