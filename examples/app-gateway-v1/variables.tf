variable "azure_region" {
  description = "Azure region to use."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "certificate_example_com_filebase64" {
  description = "Filebase64 encoded SSL certificate"
  type        = string
}

variable "certificate_example_com_password" {
  description = "Password of the SSL certificate"
  type        = string
}
