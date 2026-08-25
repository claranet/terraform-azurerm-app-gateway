terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    azurecaf = {
      source  = "claranet/azurecaf"
      version = "~> 1.3.0"
    }
  }
}
