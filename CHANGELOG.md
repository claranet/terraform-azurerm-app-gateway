## 8.2.1 (2025-09-30)

### Code Refactoring

* **deps:** 🔗 update claranet/azurecaf to ~> 1.3.0 🔧 24b7c14

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review 3508294
* 🗑️ remove old commitlint configuration files f234c9b
* **deps:** 🔗 bump AzureRM provider version to v4.31+ 462730f
* **deps:** update dependency claranet/diagnostic-settings/azurerm to ~> 8.1.0 d19053f
* **deps:** update dependency opentofu to v1.10.0 4a83605
* **deps:** update dependency opentofu to v1.10.1 b637d3e
* **deps:** update dependency opentofu to v1.10.3 266d42a
* **deps:** update dependency opentofu to v1.10.6 12a8885
* **deps:** update dependency tflint to v0.58.1 fd1b686
* **deps:** update dependency tflint to v0.59.1 b6a491b
* **deps:** update dependency trivy to v0.66.0 f79dfce
* **deps:** update dependency trivy to v0.67.0 8ba172f
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v6 ca8516d
* **deps:** update terraform claranet/diagnostic-settings/azurerm to ~> 8.2.0 425f892
* **deps:** update terraform claranet/subnet/azurerm to ~> 8.1.0 98c6e6d
* **deps:** update tools 542348f
* **deps:** update tools 6204e6c
* **deps:** update tools b03f2a7

## 8.2.0 (2025-06-20)

### Features

* ✨ update example 9590864
* 🗑️ remove WAF configuration examples and related variables e838ec2

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.63.0 51ecaa1
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 8642525
* **deps:** update terraform claranet/nsg/azurerm to ~> 8.1.0 cbd4a68

## 8.1.1 (2025-05-26)

### Bug Fixes

* **AZ-1552:** 🔧 update `azurerm` provider version to `~> 4.11` 601578d

### Miscellaneous Chores

* **deps:** update dependency tflint to v0.58.0 9769d72

## 8.1.0 (2025-05-16)

### Features

* **AZ-1552:** ✨ add `nsg_resource_group_name` variable 6563749

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.9.1 eb4f492
* **deps:** update dependency pre-commit to v4.2.0 b053ae7
* **deps:** update dependency terraform-docs to v0.20.0 7e19ace
* **deps:** update dependency tflint to v0.55.1 511d760
* **deps:** update dependency tflint to v0.56.0 fd071e1
* **deps:** update dependency trivy to v0.59.0 2b2b7e3
* **deps:** update dependency trivy to v0.59.1 69da6be
* **deps:** update dependency trivy to v0.60.0 d305f40
* **deps:** update dependency trivy to v0.61.0 920ac5f
* **deps:** update dependency trivy to v0.61.1 786a2a7
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 ae3485e
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 12971a0
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 c44a8fd
* **deps:** update tools 6cecddf
* update Github templates 2e192de

## 8.0.0 (2025-01-24)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** module v8 structure and updates edd0d87

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.6 b7be6cc
* **deps:** update dependency opentofu to v1.8.8 6b4161d
* **deps:** update dependency opentofu to v1.9.0 850713a
* **deps:** update dependency pre-commit to v4.1.0 350e031
* **deps:** update dependency tflint to v0.55.0 bf275e5
* **deps:** update dependency trivy to v0.57.1 4c3b94e
* **deps:** update dependency trivy to v0.58.1 615e027
* **deps:** update dependency trivy to v0.58.2 3fce39f
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 bef9b7f
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 6edb762
* **deps:** update tools 469e61e
* update tflint config for v0.55.0 7d362e4

## 7.9.0 (2024-11-15)

### Features

* **AZ-1480:** add firewall_policy_id parameter for path_rule block 4de6c78

### Miscellaneous Chores

* **deps:** update dependency claranet/diagnostic-settings/azurerm to v7 60ff450
* **deps:** update dependency claranet/nsg/azurerm to ~> 7.8.0 dad2090
* **deps:** update dependency claranet/subnet/azurerm to ~> 7.2.0 2ed49d1
* **deps:** update dependency opentofu to v1.8.3 957f032
* **deps:** update dependency opentofu to v1.8.4 f4c0ed4
* **deps:** update dependency pre-commit to v4 86f16ca
* **deps:** update dependency pre-commit to v4.0.1 96111dc
* **deps:** update dependency tflint to v0.54.0 5d4781c
* **deps:** update dependency trivy to v0.56.1 ea69b71
* **deps:** update dependency trivy to v0.56.2 2850b57
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 ea7b8be
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 711301b
* **deps:** update tools 145dd4c
* prepare for new examples structure 091933e
* update examples structure d008f8a

## 7.8.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider 43400af

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.56.0 6d97b24

## 7.7.3 (2024-10-01)

### Documentation

* update README badge to use OpenTofu registry cd1ac31

### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 6b4ebf7
* **AZ-1391:** update semantic-release config [skip ci] 8e0f655

### Miscellaneous Chores

* bump minimum AzureRM version 21db355
* **deps:** enable automerge on renovate e3af228
* **deps:** update dependency claranet/subnet/azurerm to ~> 7.1.0 301cc6f
* **deps:** update dependency claranet/subnet/azurerm to v7 10846e5
* **deps:** update dependency opentofu to v1.7.0 fb7a03f
* **deps:** update dependency opentofu to v1.7.1 cac35d2
* **deps:** update dependency opentofu to v1.7.2 9a5dceb
* **deps:** update dependency opentofu to v1.7.3 d102858
* **deps:** update dependency opentofu to v1.8.0 99c4018
* **deps:** update dependency opentofu to v1.8.1 8a0f154
* **deps:** update dependency opentofu to v1.8.2 967e882
* **deps:** update dependency pre-commit to v3.7.1 6d6c917
* **deps:** update dependency pre-commit to v3.8.0 dbc5f50
* **deps:** update dependency terraform-docs to v0.18.0 48384dd
* **deps:** update dependency terraform-docs to v0.19.0 c69319f
* **deps:** update dependency tflint to v0.51.0 c9ea5ba
* **deps:** update dependency tflint to v0.51.1 e759021
* **deps:** update dependency tflint to v0.51.2 1e38ba3
* **deps:** update dependency tflint to v0.52.0 50ae7d2
* **deps:** update dependency tflint to v0.53.0 becd099
* **deps:** update dependency trivy to v0.50.2 e295600
* **deps:** update dependency trivy to v0.50.4 59db26f
* **deps:** update dependency trivy to v0.51.0 db0cb2f
* **deps:** update dependency trivy to v0.51.1 97c9d63
* **deps:** update dependency trivy to v0.51.2 3447da3
* **deps:** update dependency trivy to v0.51.3 1222450
* **deps:** update dependency trivy to v0.51.4 aba5af7
* **deps:** update dependency trivy to v0.52.0 afc695a
* **deps:** update dependency trivy to v0.52.1 3d0ed9c
* **deps:** update dependency trivy to v0.52.2 abc06d9
* **deps:** update dependency trivy to v0.53.0 8ac1cee
* **deps:** update dependency trivy to v0.54.1 8d372f4
* **deps:** update dependency trivy to v0.55.0 b8d76df
* **deps:** update dependency trivy to v0.55.1 9af8d73
* **deps:** update dependency trivy to v0.55.2 637ecfa
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 84da9f5
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 e6fe48c
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 ce913e5
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 e8c22aa
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 861370e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 e1018c2
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 725b931
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 15384b3
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 01ee342
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 c7b51ac
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 4904b6e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 f58ea65
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 ece8727
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.1 166a017
* **deps:** update terraform claranet/nsg/azurerm to ~> 7.7.0 31fafa7
* **pre-commit:** update commitlint hook a690886
* **release:** remove legacy `VERSION` file bf91e02

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
