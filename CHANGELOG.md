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
