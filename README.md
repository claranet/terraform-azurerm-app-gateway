# Azure Application Gateway
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/app-gateway/azurerm/)

This Terraform module creates an [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) associated with a [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm#public-ip-addresses) and with a [Subnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet), a [Network Security Group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) and network security rules authorizing port 443 and [ports for internal healthcheck of Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/configuration-overview#network-security-groups-on-the-application-gateway-subnet). The [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-diagnostics#diagnostic-logging) are activated.

## Naming

Resource naming is based on the [Microsoft CAF naming convention best practices](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). Legacy naming is available by setting the parameter `use_caf_naming` to false.
We rely on [the official Terraform Azure CAF naming provider](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) to generate resource names.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "run_common" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  tenant_id = var.azure_tenant_id

  monitoring_function_splunk_token = null
}

module "azure_virtual_network" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  vnet_cidr = ["192.168.0.0/16"]
}


module "appgw_v2" {
  source  = "claranet/app-gateway/azurerm"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure_virtual_network.virtual_network_name
  subnet_cidr          = "192.168.1.0/24"

  appgw_backend_http_settings = [{
    name                  = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backhttpsettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 300
  }]

  appgw_backend_pools = [{
    name  = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backendpool"
    fqdns = ["example.com"]
  }]

  appgw_routings = [{
    name                       = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-routing-https"
    rule_type                  = "Basic"
    http_listener_name         = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-listener-https"
    backend_address_pool_name  = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backendpool"
    backend_http_settings_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backhttpsettings"
  }]

  appgw_http_listeners = [{
    name                           = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-listener-https"
    frontend_ip_configuration_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-frontipconfig"
    frontend_port_name             = "frontend-https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-com-sslcert"
    host_name                      = "example.com"
    require_sni                    = true
    custom_error_configuration = {
      custom1 = {
        custom_error_page_url = "https://example.com/custom_error_403_page.html"
        status_code           = "HttpStatus403"
      },
      custom2 = {
        custom_error_page_url = "https://example.com/custom_error_502_page.html"
        status_code           = "HttpStatus502"
      }
    }
  }]

  custom_error_configuration = [
    {
      custom_error_page_url = "https://example.com/custom_error_403_page.html"
      status_code           = "HttpStatus403"
    },
    {
      custom_error_page_url = "https://example.com/custom_error_502_page.html"
      status_code           = "HttpStatus502"
    }
  ]

  frontend_port_settings = [{
    name = "frontend-https-port"
    port = 443
  }]

  ssl_certificates_configs = [{
    name     = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-com-sslcert"
    data     = var.certificate_example_com_filebase64
    password = var.certificate_example_com_password
  }]

  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  appgw_rewrite_rule_set = {
    name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-rewrite-rule-set"
    rewrite_rule = [
      {
        name          = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-rewrite-rule-response-header"
        rule_sequence = 100
        condition = [
          {
            condition_ignore_case = true
            condition_negate      = false
            condition_pattern     = "text/html(.*)"
            condition_variable    = "http_resp_Content-Type"
          }
        ]
        response_header_name  = "X-Frame-Options"
        response_header_value = "DENY"
      },
      {
        name          = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-rewrite-rule-url"
        rule_sequence = 100
        condition = [
          {
            condition_ignore_case = false
            condition_negate      = false
            condition_pattern     = ".*-R[0-9]{10,10}\\.html"
            condition_variable    = "var_uri_path"
          },
          {
            condition_ignore_case = true
            condition_negate      = false
            condition_pattern     = ".*\\.fr"
            condition_variable    = "var_host"
          }
        ]
        url_path     = "/fr{var_uri_path}"
        query_string = null
        url_reroute  = false
      }
    ]
  }

  appgw_url_path_map = [
    {
      name                                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-url-path-map"
      default_backend_address_pool_name   = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backendpool"
      default_redirect_configuration_name = "Default-redirect-configuration-name"
      default_rewrite_rule_set_name       = "Default-rewrite-rule-set-name"
      path_rule = [
        {
          name                       = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-example-url-path-rule"
          backend_address_pool_name  = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backendpool"
          backend_http_settings_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-backhttpsettings"
          rewrite_rule_set_name      = "Rewrite-rule-set-name"
          paths                      = ["/"]
        }
      ]
    },
  ]

  autoscaling_parameters = {
    min_capacity = 2
    max_capacity = 15
  }

  logs_destinations_ids = [
    module.run_common.log_analytics_workspace_id,
    module.run_common.logs_storage_account_id,
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.1 |
| azurerm | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_network\_security\_group | claranet/nsg/azurerm | 5.1.0 |
| azure\_network\_subnet | claranet/subnet/azurerm | 4.2.1 |
| diagnostics | claranet/diagnostic-settings/azurerm | 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.appgw](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.frontipconfig](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.frontipconfig_priv](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.gwipconfig](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.nsg_appgw](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.nsr_healthcheck](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.nsr_https](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.pip_appgw](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.subnet_appgw](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_application_gateway.app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_network_security_rule.allow_health_probe_app_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.web](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_gateway\_tags | Application Gateway tags. | `map(string)` | `{}` | no |
| appgw\_backend\_http\_settings | List of maps including backend http settings configurations | `any` | n/a | yes |
| appgw\_backend\_pools | List of maps including backend pool configurations | `any` | n/a | yes |
| appgw\_http\_listeners | List of maps including http listeners configurations and map of maps including listener custom error configurations | `any` | n/a | yes |
| appgw\_private | Boolean variable to create a private Application Gateway. When `true`, the default http listener will listen on private IP instead of the public IP. | `bool` | `false` | no |
| appgw\_private\_ip | Private IP for Application Gateway. Used when variable `appgw_private` is set to `true`. | `string` | `null` | no |
| appgw\_probes | List of maps including request probes configurations | `any` | `[]` | no |
| appgw\_redirect\_configuration | List of maps including redirect configurations | `list(map(string))` | `[]` | no |
| appgw\_rewrite\_rule\_set | List of rewrite rule set including rewrite rules | `any` | `[]` | no |
| appgw\_routings | List of maps including request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory. | `list(map(string))` | n/a | yes |
| appgw\_url\_path\_map | List of maps including url path map configurations | `any` | `[]` | no |
| autoscaling\_parameters | Map containing autoscaling parameters. Must contain at least min\_capacity | `map(string)` | `null` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| create\_nsg | Boolean to create the network security group. | `bool` | `false` | no |
| create\_nsg\_healthprobe\_rule | Boolean to create the network security group rule for the health probes. | `bool` | `true` | no |
| create\_nsg\_https\_rule | Boolean to create the network security group rule opening https to everyone. | `bool` | `true` | no |
| create\_subnet | Boolean to create subnet with this module. | `bool` | `true` | no |
| custom\_appgw\_name | Application Gateway custom name. Generated by default. | `string` | `""` | no |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_error\_configuration | List of maps including global level custom error configurations | `list(map(string))` | `[]` | no |
| custom\_frontend\_ip\_configuration\_name | The custom name of the Frontend IP Configuration used. Generated by default. | `string` | `""` | no |
| custom\_frontend\_priv\_ip\_configuration\_name | The Name of the private Frontend IP Configuration used for this HTTP Listener. | `string` | `""` | no |
| custom\_gateway\_ip\_configuration\_name | The Name of the Application Gateway IP Configuration. | `string` | `""` | no |
| custom\_ip\_label | Domain name label for public IP. | `string` | `""` | no |
| custom\_ip\_name | Public IP custom name. Generated by default. | `string` | `""` | no |
| custom\_nsg\_name | Custom name for the network security group. | `string` | `null` | no |
| custom\_nsr\_healthcheck\_name | Custom name for the network security rule for internal health check of Application Gateway. | `string` | `null` | no |
| custom\_nsr\_https\_name | Custom name for the network security rule for HTTPS protocol. | `string` | `null` | no |
| custom\_subnet\_name | Custom name for the subnet. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| disable\_waf\_rules\_for\_dev\_portal | Whether to disable some WAF rules if the APIM developer portal is hosted behind this Application Gateway. See locals.tf for the documentation link | `bool` | `false` | no |
| disabled\_rule\_group\_settings | The rule group where specific rules should be disabled. Accepted values can be found here: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#rule_group_name | <pre>list(object({<br>    rule_group_name = string<br>    rules           = list(string)<br>  }))</pre> | `[]` | no |
| enable\_http2 | Whether to enable http2 or not | `bool` | `true` | no |
| enable\_waf | Boolean to enable WAF. | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| file\_upload\_limit\_mb | The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB. Defaults to 100MB. | `number` | `100` | no |
| firewall\_policy\_id | ID of a Web Application Firewall Policy | `string` | `null` | no |
| frontend\_port\_settings | Frontend port settings. Each port setting contains the name and the port for the frontend port. | `list(map(string))` | n/a | yes |
| ip\_allocation\_method | Allocation method for the public IP. Warning, can only be `Static` for the moment. | `string` | `"Static"` | no |
| ip\_sku | SKU for the public IP. Warning, can only be `Standard` for the moment. | `string` | `"Standard"` | no |
| ip\_tags | Public IP tags. | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account | `number` | `30` | no |
| max\_request\_body\_size\_kb | The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. | `number` | `128` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| nsg\_tags | Network Security Group tags. | `map(string)` | `{}` | no |
| nsr\_https\_source\_address\_prefix | Source address prefix to allow to access on port 443 defined in dedicated network security rule. | `string` | `"*"` | no |
| request\_body\_check | Is Request Body Inspection enabled? | `bool` | `true` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| route\_table\_name | The Route Table name to associate with the subnet | `string` | `null` | no |
| route\_table\_rg | The Route Table RG to associate with the subnet. Default is the same RG than the subnet. | `string` | `null` | no |
| rule\_set\_type | The Type of the Rule Set used for this Web Application Firewall. | `string` | `"OWASP"` | no |
| rule\_set\_version | The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1. | `number` | `3.1` | no |
| sku | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_v2 and WAF\_v2. | `string` | `"WAF_v2"` | no |
| sku\_capacity | The Capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale\_configuration is set | `number` | `2` | no |
| ssl\_certificates\_configs | List of maps including ssl certificates configurations.<br>The path to a base-64 encoded certificate is expected in the 'data' parameter:<pre>data = filebase64("./file_path")</pre> | `list(map(string))` | `[]` | no |
| ssl\_policy | Application Gateway SSL configuration. The list of available policies can be found here: https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview#predefined-ssl-policy | `any` | `null` | no |
| ssl\_profile | Application Gateway SSL profile. Default profile is used when this variable is set to null. | `any` | `null` | no |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_cidr | Subnet CIDR to create. | `string` | `""` | no |
| subnet\_id | Custom subnet ID for attaching the Application Gateway. Used only when the variable `create_subnet = false`. | `string` | `""` | no |
| subnet\_resource\_group\_name | Resource group name of the subnet. | `string` | `""` | no |
| trusted\_root\_certificate\_configs | List of trusted root certificates. The needed values for each trusted root certificates are 'name' and 'data' or 'filename'. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate) | `list(map(string))` | `[]` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_rg_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| user\_assigned\_identity\_id | User assigned identity id assigned to this resource | `string` | `null` | no |
| virtual\_network\_name | Virtual network name to attach the subnet. | `string` | n/a | yes |
| waf\_exclusion\_settings | WAF exclusion rules to exclude header, cookie or GET argument. More informations on: https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#match_variable | `list(map(string))` | `[]` | no |
| waf\_mode | The Web Application Firewall Mode. Possible values are Detection and Prevention. | `string` | `"Prevention"` | no |
| zones | A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| appgw\_backend\_address\_pool\_ids | List of backend address pool Ids. |
| appgw\_backend\_http\_settings\_ids | List of backend HTTP settings Ids. |
| appgw\_backend\_http\_settings\_probe\_ids | List of probe Ids from backend HTTP settings. |
| appgw\_custom\_error\_configuration\_ids | List of custom error configuration Ids. |
| appgw\_frontend\_ip\_configuration\_ids | List of frontend IP configuration Ids. |
| appgw\_frontend\_port\_ids | List of frontend port Ids. |
| appgw\_gateway\_ip\_configuration\_ids | List of IP configuration Ids. |
| appgw\_http\_listener\_frontend\_ip\_configuration\_ids | List of frontend IP configuration Ids from HTTP listeners. |
| appgw\_http\_listener\_frontend\_port\_ids | List of frontend port Ids from HTTP listeners. |
| appgw\_http\_listener\_ids | List of HTTP listener Ids. |
| appgw\_id | The ID of the Application Gateway. |
| appgw\_name | The name of the Application Gateway. |
| appgw\_nsg\_id | The ID of the network security group from the subnet where the Application Gateway is attached. |
| appgw\_nsg\_name | The name of the network security group from the subnet where the Application Gateway is attached. |
| appgw\_public\_ip\_address | The public IP address of Application Gateway. |
| appgw\_redirect\_configuration\_ids | List of redirect configuration Ids. |
| appgw\_request\_routing\_rule\_backend\_address\_pool\_ids | List of backend address pool Ids attached to request routing rules. |
| appgw\_request\_routing\_rule\_backend\_http\_settings\_ids | List of HTTP settings Ids attached to request routing rules. |
| appgw\_request\_routing\_rule\_http\_listener\_ids | List of HTTP listener Ids attached to request routing rules. |
| appgw\_request\_routing\_rule\_ids | List of request routing rules Ids. |
| appgw\_request\_routing\_rule\_redirect\_configuration\_ids | List of redirect configuration Ids attached to request routing rules. |
| appgw\_request\_routing\_rule\_rewrite\_rule\_set\_ids | List of rewrite rule set Ids attached to request routing rules. |
| appgw\_request\_routing\_rule\_url\_path\_map\_ids | List of URL path map Ids attached to request routing rules. |
| appgw\_ssl\_certificate\_ids | List of SSL certificate Ids. |
| appgw\_subnet\_id | The ID of the subnet where the Application Gateway is attached. |
| appgw\_subnet\_name | The name of the subnet where the Application Gateway is attached. |
| appgw\_url\_path\_map\_default\_backend\_address\_pool\_ids | List of default backend address pool Ids attached to URL path maps. |
| appgw\_url\_path\_map\_default\_backend\_http\_settings\_ids | List of default backend HTTP settings Ids attached to URL path maps. |
| appgw\_url\_path\_map\_default\_redirect\_configuration\_ids | List of default redirect configuration Ids attached to URL path maps. |
| appgw\_url\_path\_map\_ids | List of URL path map Ids. |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/application-gateway/overview](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
