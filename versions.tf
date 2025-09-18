terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.116" }
    azapi  = { source = "azure/azapi", version = "~> 2.0" } # за ACA, ако трябва
  }
}

provider "azurerm" {
  features {}
}