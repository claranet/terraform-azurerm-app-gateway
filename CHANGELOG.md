# v7.7.2 - 2024-03-28

Fixed
  * AZ-1382: Fix `ssl_profile` block - Change the type to a list of objects to allow the creation of multiple policies.

# v7.7.1 - 2023-10-06

Fixed
  * AZ-1132: Fix `url_path_map` block - Add `redirect_configuration_name` attribute in `path_rule`

# v7.7.0 - 2023-09-08

Breaking
  * AZ-1153: Remove `retention_days` parameters, it must be handled at destination level now. (for reference: [Provider issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/23051))
  * AZ-1155: Remove sub-module `app-gateway-v1` as it's deprecated by Microsoft: [Microsoft Azure announcement](https://azure.microsoft.com/en-us/updates/_application-gateway-v1-will-be-retired-on-28-april-2026-transition-to-application-gateway-v2/)

Fixed
  * AZ-1132: Fix `url_path_map` block
  * AZ-1158: Fix missing `Microsoft.KeyVault` service endpoint on managed subnet

# v7.6.0 - 2023-08-11

Changed
  * AZ-1117: The `virtual_network_name` variable is no longer required
  * AZ-1117: The `ip_ddos_protection_mode` variable is set to `null` by default, the value will be inherited from the AzureRM provider which is `VirtualNetworkInherited`
  * AZ-1117: The `source_address_prefix` parameter is set to `GatewayManager` instead of `Internet` for the healthcheck Network Security Rule
  * AZ-1117: Bump Subnet & NSG modules

# v7.5.1 - 2023-07-13

Fixed
  * AZ-1113: Update sub-modules READMEs (according to their example)

# v7.5.0 - 2023-02-13

Changed
  * [GH-12](https://github.com/claranet/terraform-azurerm-app-gateway/pull/12): Modify `appgw_probes` allowing port-usage from backend HTTP settings

Fixed
  * AZ-990: Fix `default_backend_http_settings_name` parameter because it cannot be set when `default_redirect_configuration_name` is set in the `url_path_map` block

# v7.4.2 - 2023-01-27

Fixed
  * AZ-987: Fix `ssl_policy` parameter because `min_protocol_version` is only supported when `policy_type = "Custom"`

# v7.4.1 - 2022-12-23

Added
  * [GH-11](https://github.com/claranet/terraform-azurerm-app-gateway/pull/11): Add domain related outputs

# v7.4.0 - 2022-12-16

Added
  * AZ-928: Add authentication and client certificates parameters

# v7.3.0 - 2022-12-14

Added
  * AZ-939: Add `ip_ddos_protection_mode` and `ip_ddos_protection_plan_id` parameters for the public IP resource

# v7.2.1 - 2022-11-25

Changed
  * AZ-908: Bump Subnet & NSG modules

# v7.2.0 - 2022-11-25

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)
  * AZ-903: Rework WAF configuration block

# v7.1.1 - 2022-11-04

Fixed
  * AZ-883: Lint code, fix deprecated HCL syntax

# v7.1.0 - 2022-10-14

Changed
  * AZ-876: Type variables with `list(object)` instead of `any`, default values, more maintainable code.

# v7.0.1 - 2022-10-13

Fixed
  * AZ-876: Update example to be useable out of the box

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `v1.3`

Changed
  * AZ-844: Bump `subnet` & `nsg` modules to latest version

# v6.0.0 - 2022-06-30

Changed
  * AZ-769: Update module to AzureRM V3

# v5.5.0 - 2022-06-24

Added
  * AZ-782: Add `nsg_tags`

Changed
  * AZ-782: Merge `extra_tags` with `pip_tags`, `app_gateway_tags`, `nsg_tags`

# v5.4.0 - 2022-04-22

Added
  * AZ-724: Add `priority` attribute in `request_routing_rule` content block
  * AZ-698: Add `firewall_policy_id` variable
  * AZ-698: Add `rewrite_rule_set_name` parameter in `url_path_map`

Fixed
  * AZ-675: Fix `frontend_ip_configuration_name` attribute lookup in `http_listener` blocks

# v5.3.0 - 2022-02-18

Added
  * AZ-675: Add `ssl_profile_name` and `host_names` attributes in `http_listener` content block

# v5.2.0 - 2022-02-11

Added
  * AZ-615: Add an option to enable or disable default tags
  * AZ-675: Add `ssl_profile` block available in parameters
  * AZ-675: Bump minimum version of `AzureRM` provider to `v2.76` (`azurerm_application_gateway` - mTLS support for Application Gateways (#13273))

# v5.1.1 - 2022-01-19

Changed
  * AZ-594: Upgrade `diagnostics` module to `v5.0.0`

# v5.1.0 - 2021-11-23

Fixed
  * AZ-589: Avoid plan drift when specifying Diagnostic Settings categories

Changed
  * AZ-574: Fix `rewrite_rule_set` block to manage `url` parameter and make possible to use several `conditions`

# v5.0.0 - 2021-10-04

Breaking
  * AZ-546: Clean module, remove unused variables, needs a `terraform state mv` for renamed modules
  * AZ-521: Revamp variables names, module cleanup
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-515: Require Terraform 0.13+
  * AZ-484: CI updated, module now optimized for Terraform 1.0+

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-572: Revamp examples and improve CI

Fixed
  * AZ-530: Fix provider required version

# v4.8.0 - 2021-06-25

Added
  * AZ-512: Improvements on `rewrite_rule_set` block

Fixed
  * AZ-494: Fix `request_routing_rule` block to manage `redirect_configuration_name` parameter

# v4.7.0 - 2021-06-07

Breaking
  * AZ-160: Unify diagnostics settings on all Claranet modules

Fixed
  * AZ-503: url_path_map hash key `paths` transform input as list, so it wasn't possible to pass a list as expected. Now flattening to be sure to have a list

# v4.6.0 - 2021-04-30

Breaking
  * AZ-490: Change `trusted_root_certificate_configs` variable usage: it must contains `filename` pointing to the certificate path or `data` with the certificate content in base64 format

# v4.5.1 - 2021-04-01

Fixed
  * AZ-429: Fix autoscaling parameters default value

# v4.5.0 - 2021-04-01

Added
  * AZ-463: Add `custom_error_configuration` to the global level and `http_listener` block in order to permit custom error pages usage
  * AZ-429: Add autoscaling parameters

Fixed
  * AZ-449: Update default value for `policy_name` parameter in `ssl_policy` block

# v4.4.1 - 2021-02-23

Fixed
  * AZ-449: Fix `ssl_policy` type and usage

# v4.4.0 - 2021-02-22

Added
  * AZ-450: Added `firewall_policy_id` to the `http_listener` block in order to permit a link between custom WAF policies and listeners

Breaking
  * AZ-449: Change `ssl_policy` input parameter type to `map(any)` (we cannot have multiple policies)

# v4.3.0 - 2021-01-22

Updated
  * AZ-399: Added `default_redirect_configuration_name` to the `url_path_map` block in order to permit simultaneous usage of `appgw_redirect_configuration`

# v4.2.0 - 2021-01-07

Updated
  * AZ-422: Remove unused variable `app_gateway_subnet_id`

Added
  * AZ-392: Possibility to deactivate some WAF rules in case there's an APIM developer portal behind the Application Gateway

# v4.1.0 - 2020-12-11

Added
  * AZ-376: Add `enable_http2` parameter, handle `ip_addresses` param on `backend_pool` block
  * AZ-378: Add ability to create a private Application Gateway with HTTP listener on private IP

Updated:
  * AZ-378: Lowercase default generated name

# v3.2.1/v4.0.0 - 2020-11-19

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.2.0 - 2020-11-17

Added
  * AZ-244: Add new variables for NSG rules and user identity

# v3.1.0 - 2020-11-10

Added
  * AZ-183: Add unmaintained module for Application Gateway v1

# v3.0.1 - 2020-08-31

Fixed
  * AZ-260: Fix outputs problems on destroy

# v3.0.0 - 2020-07-28

Breaking
  * AZ-198: Upgrade module to be compliant with AzureRM 2.0

# v2.0.0 - 2020-07-27

Added
  * AZ-183: First release for Application Gateway v2
