# Azure Application Gateway
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/app-gateway/azurerm/)

This Terraform module creates an [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) associated with a [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm#public-ip-addresses) and with a [Subnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet), a [Network Security Group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) and network security rules authorizing port 443 and [ports for internal healthcheck of Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/configuration-overview#network-security-groups-on-the-application-gateway-subnet). The [Diagnostics Logs](https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-diagnostics#diagnostic-logging) are activated.

## Naming

Resource naming is based on the [Microsoft CAF naming convention best practices](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). Legacy naming is available by setting the parameter `use_caf_naming` to false.
We rely on [the official Terraform Azure CAF naming provider](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) to generate resource names.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
module "azure_virtual_network" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.name

  cidrs = ["192.168.0.0/16"]
}

locals {
  base_name = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}"
}

module "appgw" {
  source  = "claranet/app-gateway/azurerm"
  version = "x.x.x"

  stack               = var.stack
  environment         = var.environment
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  resource_group_name = module.rg.name

  virtual_network_name = module.azure_virtual_network.name
  subnet_cidr          = "192.168.1.0/24"

  backend_http_settings = [
    {
      name                  = "${local.base_name}-backhttpsettings-http"
      cookie_based_affinity = "Disabled"
      path                  = "/"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 300
    },
    # {
    #   name                  = "${local.base_name}-backhttpsettings-https"
    #   cookie_based_affinity = "Disabled"
    #   path                  = "/"
    #   port                  = 443
    #   protocol              = "Https"
    #   request_timeout       = 300
    # }
  ]

  backend_address_pools = [{
    name  = "${local.base_name}-backendpool"
    fqdns = ["example.com"]
  }]

  request_routing_rules = [
    {
      name                       = "${local.base_name}-routing-http"
      rule_type                  = "Basic"
      http_listener_name         = "${local.base_name}-listener-http"
      backend_address_pool_name  = "${local.base_name}-backendpool"
      backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
    },
    # {
    #   name                       = "${local.base_name}-routing-https"
    #   rule_type                  = "Basic"
    #   http_listener_name         = "${local.base_name}-listener-https"
    #   backend_address_pool_name  = "${local.base_name}-backendpool"
    #   backend_http_settings_name = "${local.base_name}-backhttpsettings-https"
    # }
  ]

  frontend_ip_configuration_custom_name = "${local.base_name}-frontipconfig"

  http_listeners = [
    {
      name                           = "${local.base_name}-listener-http"
      frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
      frontend_port_name             = "frontend-http-port"
      protocol                       = "Http"
      host_name                      = "example.com"
    },
    # {
    #   name                           = "${local.base_name}-listener-https"
    #   frontend_ip_configuration_name = "${local.base_name}-frontipconfig"
    #   frontend_port_name             = "frontend-https-port"
    #   protocol                       = "Https"
    #   ssl_certificate_name           = "${local.base_name}-example-com-sslcert"
    #   require_sni                    = true
    #   host_name                      = "example.com"
    # }
  ]

  frontend_ports = [{
    name = "frontend-http-port"
    port = 80
  }]

  #  ssl_certificates = [{
  #    name     = "${local.base_name}-example-com-sslcert"
  #    data     = var.certificate_example_com_filebase64
  #    password = var.certificate_example_com_password
  #  }]

  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  rewrite_rule_sets = [{
    name = "${local.base_name}-example-rewrite-rule-set"
    rewrite_rules = [
      {
        name          = "${local.base_name}-example-rewrite-rule-response-header"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = true
            negate      = false
            pattern     = "text/html(.*)"
            variable    = "http_resp_Content-Type"
          }
        ]
        response_header_configurations = [{
          header_name  = "X-Frame-Options"
          header_value = "DENY"
        }]
      },
      {
        name          = "${local.base_name}-example-rewrite-rule-url"
        rule_sequence = 100
        conditions = [
          {
            ignore_case = false
            negate      = false
            pattern     = ".*-R[0-9]{10,10}\\.html"
            variable    = "var_uri_path"
          },
          {
            ignore_case = true
            negate      = false
            pattern     = ".*\\.fr"
            variable    = "var_host"
          }
        ]
        url_reroute = {
          path         = "/fr{var_uri_path}"
          query_string = null
          reroute      = false
        }
      }
    ]
  }]

  url_path_maps = [
    {
      name                               = "${local.base_name}-example-url-path-map"
      default_backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
      default_backend_address_pool_name  = "${local.base_name}-backendpool"
      default_rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
      # default_redirect_configuration_name = "${local.base_name}-redirect"
      path_rules = [
        {
          name                       = "${local.base_name}-example-url-path-rule"
          backend_address_pool_name  = "${local.base_name}-backendpool"
          backend_http_settings_name = "${local.base_name}-backhttpsettings-http"
          rewrite_rule_set_name      = "${local.base_name}-example-rewrite-rule-set"
          paths                      = ["/demo/"]
        }
      ]
    }
  ]

  # Disabled WAF rule and WAF exclusion configuration example
  # waf_configuration = {
  #   disabled_rule_group = [
  #     {
  #       rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
  #       rules           = ["920420", "920320", "920330"]
  #     }
  #   ]
  #   exclusion = [
  #     {
  #       match_variable          = "RequestArgNames"
  #       selector                = "picture"
  #       selector_match_operator = "Equals"
  #     }
  #   ]
  # }

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 15
  }

  logs_destinations_ids = [
    # module.logs.id,
    # module.logs.storage_account_id,
  ]
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.28 |
| azurerm | ~> 4.11 |
| terraform | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | ~> 8.0.0 |
| nsg | claranet/nsg/azurerm | ~> 8.1.0 |
| subnet | claranet/subnet/azurerm | ~> 8.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [terraform_data.create_subnet_condition](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [azurecaf_name.appgw](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.frontipconfig](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.frontipconfig_priv](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.gwipconfig](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nsg_appgw](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nsr_healthcheck](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nsr_https](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.pip_appgw](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.subnet_appgw](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_gateway\_tags | Application Gateway tags. | `map(string)` | `{}` | no |
| authentication\_certificates | List of objects with authentication certificates configurations.<br/>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br/>    name = string<br/>    data = string<br/>  }))</pre> | `[]` | no |
| autoscale\_configuration | Map containing autoscaling parameters. Must contain at least min\_capacity. | <pre>object({<br/>    min_capacity = number<br/>    max_capacity = optional(number, 5)<br/>  })</pre> | `null` | no |
| backend\_address\_pools | List of objects with backend pool configurations. | <pre>list(object({<br/>    name         = string<br/>    fqdns        = optional(list(string))<br/>    ip_addresses = optional(list(string))<br/>  }))</pre> | n/a | yes |
| backend\_http\_settings | List of objects including backend http settings configurations. | <pre>list(object({<br/>    name     = string<br/>    port     = optional(number, 443)<br/>    protocol = optional(string, "Https")<br/><br/>    path       = optional(string)<br/>    probe_name = optional(string)<br/><br/>    cookie_based_affinity               = optional(string, "Disabled")<br/>    affinity_cookie_name                = optional(string, "ApplicationGatewayAffinity")<br/>    request_timeout                     = optional(number, 20)<br/>    host_name                           = optional(string)<br/>    pick_host_name_from_backend_address = optional(bool, true)<br/>    trusted_root_certificate_names      = optional(list(string), [])<br/>    authentication_certificate          = optional(string)<br/><br/>    connection_draining_timeout_sec = optional(number)<br/>  }))</pre> | n/a | yes |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| create\_nsg | Boolean to create the network security group. | `bool` | `false` | no |
| create\_nsg\_healthprobe\_rule | Boolean to create the network security group rule for the health probes. | `bool` | `true` | no |
| create\_nsg\_https\_rule | Boolean to create the network security group rule opening https to everyone. | `bool` | `true` | no |
| create\_subnet | Boolean to create subnet with this module. | `bool` | `true` | no |
| custom\_error\_configurations | List of objects with global level custom error configurations. | <pre>list(object({<br/>    status_code           = string<br/>    custom_error_page_url = string<br/>  }))</pre> | `[]` | no |
| custom\_name | Custom Application Gateway name, generated if not set. | `string` | `""` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostic\_settings\_custom\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| environment | Project environment. | `string` | n/a | yes |
| extra\_tags | Extra tags to add. | `map(string)` | `{}` | no |
| firewall\_policy\_id | ID of a Web Application Firewall Policy. | `string` | `null` | no |
| flow\_log\_enabled | Provision network watcher flow logs. | `bool` | `false` | no |
| flow\_log\_location | The location where the Network Watcher Flow Log resides. Changing this forces a new resource to be created. Defaults to the `location` of the Network Watcher. | `string` | `null` | no |
| flow\_log\_logging\_enabled | Enable Network Flow Logging. | `bool` | `true` | no |
| flow\_log\_retention\_policy\_days | The number of days to retain flow log records. | `number` | `31` | no |
| flow\_log\_retention\_policy\_enabled | Boolean flag to enable/disable retention. | `bool` | `true` | no |
| flow\_log\_storage\_account\_id | Network watcher flow log storage account ID. | `string` | `null` | no |
| flow\_log\_traffic\_analytics\_enabled | Boolean flag to enable/disable traffic analytics. | `bool` | `true` | no |
| flow\_log\_traffic\_analytics\_interval\_in\_minutes | How frequently service should do flow analytics in minutes. | `number` | `10` | no |
| force\_firewall\_policy\_association | Enable if the Firewall Policy is associated with the Application Gateway. | `bool` | `false` | no |
| frontend\_ip\_configuration\_custom\_name | The custom name of the Frontend IP Configuration used. Generated by default. | `string` | `""` | no |
| frontend\_ports | List of objects with frontend ports. Each one contains the name and the port for the frontend port. | <pre>list(object({<br/>    name = string<br/>    port = number<br/>  }))</pre> | `[]` | no |
| frontend\_private\_ip\_configuration | Configuration of frontend private IP. | <pre>object({<br/>    private_ip_address_allocation = optional(string, "Static")<br/>    private_ip_address            = optional(string)<br/>  })</pre> | `null` | no |
| frontend\_private\_ip\_configuration\_custom\_name | The Name of the private Frontend IP Configuration used for this HTTP Listener. | `string` | `""` | no |
| gateway\_ip\_configuration\_custom\_name | The Name of the Application Gateway IP Configuration. | `string` | `""` | no |
| http2\_enabled | Whether to enable http2 or not. | `bool` | `true` | no |
| http\_listeners | List of objects with HTTP listeners configurations and custom error configurations. | <pre>list(object({<br/>    name = string<br/><br/>    frontend_ip_configuration_name = optional(string)<br/>    frontend_port_name             = optional(string)<br/>    host_name                      = optional(string)<br/>    host_names                     = optional(list(string))<br/>    protocol                       = optional(string, "Https")<br/>    require_sni                    = optional(bool, false)<br/>    ssl_certificate_name           = optional(string)<br/>    ssl_profile_name               = optional(string)<br/>    firewall_policy_id             = optional(string)<br/><br/>    custom_error_configurations = optional(list(object({<br/>      status_code           = string<br/>      custom_error_page_url = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| ip\_tags | Public IP tags. | `map(string)` | `{}` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_workspace\_guid | The resource GUID of the attached workspace. | `string` | `null` | no |
| log\_analytics\_workspace\_id | The resource ID of the attached workspace. | `string` | `null` | no |
| log\_analytics\_workspace\_location | The location of the attached workspace. | `string` | `null` | no |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br/>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br/>If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new resource to be created. | `string` | `null` | no |
| network\_watcher\_resource\_group\_name | The name of the resource group in which the Network Watcher was deployed. Changing this forces a new resource to be created. | `string` | `null` | no |
| nsg\_custom\_name | Custom name for the network security group. | `string` | `null` | no |
| nsg\_resource\_group\_name | Resource group name of the network security group. | `string` | `null` | no |
| nsg\_tags | Network Security Group tags. | `map(string)` | `{}` | no |
| nsr\_healthcheck\_custom\_name | Custom name for the network security rule for internal health check of Application Gateway. | `string` | `null` | no |
| nsr\_https\_custom\_name | Custom name for the network security rule for HTTPS protocol. | `string` | `null` | no |
| nsr\_https\_source\_address\_prefix | Source address prefix to allow to access on port 443 defined in dedicated network security rule. | `string` | `"*"` | no |
| probes | List of objects with probes configurations. | <pre>list(object({<br/>    name     = string<br/>    host     = optional(string)<br/>    port     = optional(number, null)<br/>    interval = optional(number, 30)<br/>    path     = optional(string, "/")<br/>    protocol = optional(string, "Https")<br/>    timeout  = optional(number, 30)<br/><br/>    unhealthy_threshold                       = optional(number, 3)<br/>    pick_host_name_from_backend_http_settings = optional(bool, false)<br/>    minimum_servers                           = optional(number, 0)<br/><br/>    match = optional(object({<br/>      body        = optional(string, "")<br/>      status_code = optional(list(string), ["200-399"])<br/>    }), {})<br/>  }))</pre> | `[]` | no |
| public\_ip | Public IP parameters. | <pre>object({<br/>    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")<br/>    ddos_protection_plan_id = optional(string)<br/>    extra_tags              = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| public\_ip\_custom\_name | Public IP custom name. Generated by default. | `string` | `""` | no |
| public\_ip\_label\_custom\_name | Domain name label for public IP. | `string` | `""` | no |
| redirect\_configurations | List of objects with redirect configurations. | <pre>list(object({<br/>    name = string<br/><br/>    redirect_type        = optional(string, "Permanent")<br/>    target_listener_name = optional(string)<br/>    target_url           = optional(string)<br/><br/>    include_path         = optional(bool, true)<br/>    include_query_string = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| request\_routing\_rules | List of objects with request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory. | <pre>list(object({<br/>    name                        = string<br/>    rule_type                   = optional(string, "Basic")<br/>    http_listener_name          = optional(string)<br/>    backend_address_pool_name   = optional(string)<br/>    backend_http_settings_name  = optional(string)<br/>    url_path_map_name           = optional(string)<br/>    redirect_configuration_name = optional(string)<br/>    rewrite_rule_set_name       = optional(string)<br/>    priority                    = optional(number)<br/>  }))</pre> | n/a | yes |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| rewrite\_rule\_sets | List of rewrite rule set objects with rewrite rules. | <pre>list(object({<br/>    name = string<br/>    rewrite_rules = list(object({<br/>      name          = string<br/>      rule_sequence = string<br/><br/>      conditions = optional(list(object({<br/>        variable    = string<br/>        pattern     = string<br/>        ignore_case = optional(bool, false)<br/>        negate      = optional(bool, false)<br/>      })), [])<br/><br/>      response_header_configurations = optional(list(object({<br/>        header_name  = string<br/>        header_value = string<br/>      })), [])<br/><br/>      request_header_configurations = optional(list(object({<br/>        header_name  = string<br/>        header_value = string<br/>      })), [])<br/><br/>      url_reroute = optional(object({<br/>        path         = optional(string)<br/>        query_string = optional(string)<br/>        components   = optional(string)<br/>        reroute      = optional(bool)<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |
| route\_table\_name | The Route Table name to associate with the subnet | `string` | `null` | no |
| route\_table\_rg | The Route Table RG to associate with the subnet. Default is the same RG than the subnet. | `string` | `null` | no |
| sku | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_v2 and WAF\_v2. | `string` | `"WAF_v2"` | no |
| sku\_capacity | The capacity of the SKU to use for this Application Gateway - which must be between 1 and 10, optional if autoscale\_configuration is set. | `number` | `2` | no |
| ssl\_certificates | List of objects with SSL certificates configurations.<br/>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br/>    name                = string<br/>    data                = optional(string)<br/>    password            = optional(string)<br/>    key_vault_secret_id = optional(string)<br/>  }))</pre> | `[]` | no |
| ssl\_policy | List of objects with SSL configurations. The list of available policies can be found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#disabled_protocols). | <pre>object({<br/>    disabled_protocols   = optional(list(string), [])<br/>    policy_type          = optional(string, "Predefined")<br/>    policy_name          = optional(string, "AppGwSslPolicy20170401S")<br/>    cipher_suites        = optional(list(string), [])<br/>    min_protocol_version = optional(string, "TLSv1_2")<br/>  })</pre> | `{}` | no |
| ssl\_profiles | List of objects with SSL profiles. Default profile is used when this variable is set to null. | <pre>list(object({<br/>    name                             = string<br/>    trusted_client_certificate_names = optional(list(string), [])<br/>    verify_client_cert_issuer_dn     = optional(bool, false)<br/>    ssl_policy = optional(object({<br/>      disabled_protocols   = optional(list(string), [])<br/>      policy_type          = optional(string, "Predefined")<br/>      policy_name          = optional(string, "AppGwSslPolicy20170401S")<br/>      cipher_suites        = optional(list(string), [])<br/>      min_protocol_version = optional(string, "TLSv1_2")<br/>    }))<br/>  }))</pre> | `[]` | no |
| stack | Project stack name. | `string` | n/a | yes |
| subnet\_cidr | Subnet CIDR to create. | `string` | `""` | no |
| subnet\_custom\_name | Custom name for the subnet. | `string` | `""` | no |
| subnet\_id | Custom subnet ID for attaching the Application Gateway. Used only when the variable `create_subnet = false`. | `string` | `""` | no |
| subnet\_resource\_group\_name | Resource group name of the subnet. | `string` | `""` | no |
| trusted\_client\_certificates | List of objects with trusted client certificates configurations.<br/>The path to a base-64 encoded certificate is expected in the 'data' attribute:<pre>data = filebase64("./file_path")</pre> | <pre>list(object({<br/>    name = string<br/>    data = string<br/>  }))</pre> | `[]` | no |
| trusted\_root\_certificates | List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate). | <pre>list(object({<br/>    name                = string<br/>    data                = optional(string)<br/>    file_path           = optional(string)<br/>    key_vault_secret_id = optional(string)<br/>  }))</pre> | `[]` | no |
| url\_path\_maps | List of objects with URL path map configurations. | <pre>list(object({<br/>    name = string<br/><br/>    default_backend_address_pool_name   = optional(string)<br/>    default_redirect_configuration_name = optional(string)<br/>    default_backend_http_settings_name  = optional(string)<br/>    default_rewrite_rule_set_name       = optional(string)<br/><br/>    path_rules = list(object({<br/>      name = string<br/><br/>      backend_address_pool_name   = optional(string)<br/>      backend_http_settings_name  = optional(string)<br/>      rewrite_rule_set_name       = optional(string)<br/>      redirect_configuration_name = optional(string)<br/>      firewall_policy_id          = optional(string)<br/><br/>      paths = optional(list(string), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| user\_assigned\_identity\_id | User assigned identity id assigned to this resource. | `string` | `null` | no |
| virtual\_network\_name | Virtual network name to attach the subnet. | `string` | `null` | no |
| waf\_configuration | WAF configuration object (only available with WAF\_v2 SKU) with following attributes:<pre>- enabled:                  Boolean to enable WAF.<br/>- file_upload_limit_mb:     The File Upload Limit in MB. Accepted values are in the range 1MB to 500MB.<br/>- firewall_mode:            The Web Application Firewall Mode. Possible values are Detection and Prevention.<br/>- max_request_body_size_kb: The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB.<br/>- request_body_check:       Is Request Body Inspection enabled ?<br/>- rule_set_type:            The Type of the Rule Set used for this Web Application Firewall.<br/>- rule_set_version:         The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1.<br/>- disabled_rule_group:      The rule group where specific rules should be disabled. Accepted values can be found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#rule_group_name).<br/>- exclusion:                WAF exclusion rules to exclude header, cookie or GET argument. More informations [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway#match_variable).</pre> | <pre>object({<br/>    enabled                  = optional(bool, true)<br/>    file_upload_limit_mb     = optional(number, 100)<br/>    firewall_mode            = optional(string, "Prevention")<br/>    max_request_body_size_kb = optional(number, 128)<br/>    request_body_check       = optional(bool, true)<br/>    rule_set_type            = optional(string, "OWASP")<br/>    rule_set_version         = optional(string, "3.1")<br/>    disabled_rule_group = optional(list(object({<br/>      rule_group_name = string<br/>      rules           = optional(list(string))<br/>    })), [])<br/>    exclusion = optional(list(object({<br/>      match_variable          = string<br/>      selector                = optional(string)<br/>      selector_match_operator = optional(string)<br/>    })), [])<br/>  })</pre> | `{}` | no |
| waf\_rules\_for\_dev\_portal\_enabled | Whether to enabled some WAF rules if the APIM developer portal is hosted behind this Application Gateway. See locals.tf for the documentation link. | `bool` | `true` | no |
| zones | A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_address\_pool\_ids | List of backend address pool IDs. |
| backend\_http\_settings\_ids | List of backend HTTP settings IDs. |
| backend\_http\_settings\_probe\_ids | List of probe IDs from backend HTTP settings. |
| custom\_error\_configuration\_ids | List of custom error configuration IDs. |
| frontend\_ip\_configuration\_ids | List of frontend IP configuration IDs. |
| frontend\_port\_ids | List of frontend port IDs. |
| gateway\_ip\_configuration\_ids | List of IP configuration IDs. |
| http\_listener\_frontend\_ip\_configuration\_ids | List of frontend IP configuration IDs from HTTP listeners. |
| http\_listener\_frontend\_port\_ids | List of frontend port IDs from HTTP listeners. |
| http\_listener\_ids | List of HTTP listener IDs. |
| id | Application Gateway ID. |
| module\_nsg | Network Security Group module object. |
| module\_subnet | Subnet module object. |
| name | Application Gateway name. |
| nsg\_id | The ID of the network security group from the subnet where the Application Gateway is attached. |
| nsg\_name | The name of the network security group from the subnet where the Application Gateway is attached. |
| public\_ip\_address | The public IP address of Application Gateway. |
| public\_ip\_domain\_name | Domain Name part from FQDN of the A DNS record associated with the public IP. |
| public\_ip\_fqdn | Fully qualified domain name of the A DNS record associated with the public IP. |
| redirect\_configuration\_ids | List of redirect configuration IDs. |
| request\_routing\_rule\_backend\_address\_pool\_ids | List of backend address pool IDs attached to request routing rules. |
| request\_routing\_rule\_backend\_http\_settings\_ids | List of HTTP settings IDs attached to request routing rules. |
| request\_routing\_rule\_http\_listener\_ids | List of HTTP listener ICs attached to request routing rules. |
| request\_routing\_rule\_ids | List of request routing rules IDs. |
| request\_routing\_rule\_redirect\_configuration\_ids | List of redirect configuration IDs attached to request routing rules. |
| request\_routing\_rule\_rewrite\_rule\_set\_ids | List of rewrite rule set IDs attached to request routing rules. |
| request\_routing\_rule\_url\_path\_map\_ids | List of URL path map IDs attached to request routing rules. |
| resource | Application Gateway resource object. |
| resource\_public\_ip | Public IP resource object. |
| ssl\_certificate\_ids | List of SSL certificate IDs. |
| subnet\_id | The ID of the subnet where the Application Gateway is attached. |
| subnet\_name | The name of the subnet where the Application Gateway is attached. |
| url\_path\_map\_default\_backend\_address\_pool\_ids | List of default backend address pool IDs attached to URL path maps. |
| url\_path\_map\_default\_backend\_http\_settings\_ids | List of default backend HTTP settings IDs attached to URL path maps. |
| url\_path\_map\_default\_redirect\_configuration\_ids | List of default redirect configuration IDs attached to URL path maps. |
| url\_path\_map\_ids | List of URL path map IDs. |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/application-gateway/overview](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
