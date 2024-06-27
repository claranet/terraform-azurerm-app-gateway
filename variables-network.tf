variable "public_ip" {
  description = "Public IP parameters."
  type = object({
    ddos_protection_mode    = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id = optional(string)
    extra_tags              = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "virtual_network_name" {
  description = "Virtual network name to attach the subnet."
  type        = string
  default     = null
}

variable "subnet_resource_group_name" {
  description = "Resource group name of the subnet."
  type        = string
  default     = ""
}

variable "create_subnet" {
  description = "Boolean to create subnet with this module."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Custom subnet ID for attaching the Application Gateway. Used only when the variable `create_subnet = false`."
  type        = string
  nullable    = false
  default     = ""
}

variable "route_table_name" {
  description = "The Route Table name to associate with the subnet"
  type        = string
  default     = null
}

variable "route_table_rg" {
  description = "The Route Table RG to associate with the subnet. Default is the same RG than the subnet."
  type        = string
  default     = null
}

variable "subnet_cidr" {
  description = "Subnet CIDR to create."
  type        = string
  default     = ""
}

variable "create_nsg" {
  description = "Boolean to create the network security group."
  type        = bool
  default     = false
}

variable "create_nsg_https_rule" {
  description = "Boolean to create the network security group rule opening https to everyone."
  type        = bool
  default     = true
}

variable "create_nsg_healthprobe_rule" {
  description = "Boolean to create the network security group rule for the health probes."
  type        = bool
  default     = true
}

variable "nsr_https_source_address_prefix" {
  description = "Source address prefix to allow to access on port 443 defined in dedicated network security rule."
  type        = string
  default     = "*"
}
