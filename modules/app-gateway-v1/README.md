# Azure Application Gateway v1
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](../../CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](../../NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](../../LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/app-gateway/azurerm/latest/submodules/app-gateway-v1)

This Terraform module creates an [Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) associated with a [Public IP](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-ip-addresses-overview-arm#public-ip-addresses) and with a [Subnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet), a [Network Security Group](https://docs.microsoft.com/en-us/azure/virtual-network/security-overview) and network security rules authorizing port 443 and [ports for internal healthcheck of Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/configuration-overview#network-security-groups-on-the-application-gateway-subnet).

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
| >= 3.x.x          | 0.12.x            | >= 2.1          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

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

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure-app-gateway" {
  source  = "claranet/app-gateway/azurerm//modules/app-gateway-v1"
  version = "x.x.x"

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  virtual_network_name = module.azure-network-vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.0.0/24"]

  sku {
      name     = "Standard_Large"
      tier     = "Standard"
      capacity = "2"
  }

  appgw_http_listeners {
      name                  = "toto_listener"
      port                  = 443
      host_name             = "the.test.com"
      protocol              = "Https"
      ssl_certificate_name  = "cert_the_test_com.p12"
  }

  appgw_backend_pools {
      name  = "toto_backend"
      fqdns = ["url.backend.target"]
  }

  appgw_backend_http_settings {
      name       = "toto_backend_http_settings"
      port       = 443
      protocol   = "Https"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| appgw\_backend\_http\_settings | List of maps including backend http settings configurations | `list(map(string))` | n/a | yes |
| appgw\_backend\_pools | List of objects including backend pool configurations | <pre>list(object({<br>    name  = string<br>    fqdns = list(string)<br>  }))</pre> | n/a | yes |
| appgw\_http\_listeners | List of maps including http listeners configurations | `list(map(string))` | n/a | yes |
| appgw\_probes | List of maps including request probes configurations | `list(map(string))` | n/a | yes |
| appgw\_redirect\_configuration | List of maps including redirect configurations | `list(map(string))` | `[]` | no |
| appgw\_routings | List of maps including request routing rules configurations | `list(map(string))` | n/a | yes |
| appgw\_url\_path\_map | List of maps including url path map configurations | <pre>list(object({<br>    name                               = string<br>    default_backend_address_pool_name  = string<br>    default_backend_http_settings_name = string<br>    path_rule = list(object({<br>      name                       = string<br>      backend_address_pool_name  = string<br>      backend_http_settings_name = string<br>      paths                      = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| authentication\_certificate\_configs | List of maps including authentication certificate configurations | `list(map(string))` | n/a | yes |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_appgw\_name | Name of the Application Gateway, generated if not set. | `string` | `""` | no |
| custom\_ippub\_name | Name of the Public IP, generated if not set. | `string` | `""` | no |
| custom\_security\_group\_name | Custom Network Security Group name, generated if not set | `string` | `""` | no |
| disabled\_rule\_group\_settings | List of objects including rule groups to disable | <pre>list(object({<br>    rule_group_name = string<br>    rules           = list(string)<br>  }))</pre> | `[]` | no |
| domain\_name\_label | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. | `string` | `""` | no |
| enable\_http2 | Enable HTTP2 | `bool` | `true` | no |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| frontend\_port | A list of ports used for the Frontend Port. Can be empty | `list(string)` | `[]` | no |
| ip\_allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic. | `string` | `"Dynamic"` | no |
| ip\_sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | `string` | `"Basic"` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| sku | Map to define the sku of the Application Gateway: Standard(Small, Medium, Large) or WAF (Medium, Large), and the capacity (between 1 and 10) | `map(string)` | n/a | yes |
| ssl\_certificates\_configs | List of maps including ssl certificates configurations | `list(map(string))` | n/a | yes |
| ssl\_policy | A map used to configured SSL policy if defined | `map(string)` | `{}` | no |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_cidr\_list | List of CIDRs to create Application Gateway dedicated subnet | `list(string)` | n/a | yes |
| virtual\_network\_name | Name of the Virtual Network where we'll create the Application Gateway dedicated subnet | `string` | n/a | yes |
| waf\_configuration\_settings | A map used to configured WAF if defined | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_gateway\_id | Application Gateway ID |
| network\_security\_group\_id | Network Security Group ID of the subnet where is Application Gateway |

## Related documentation

Terraform resource documentation: [www.terraform.io/docs/providers/azurerm/r/virtual_machine.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/application-gateway/overview](https://docs.microsoft.com/en-us/azure/application-gateway/overview)
