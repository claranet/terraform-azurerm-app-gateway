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
