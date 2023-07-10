terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.32"
    }
  }
}

provider "azurerm" {
  features {}
}
