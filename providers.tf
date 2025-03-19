
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "b9879c18-e8da-4c85-a9de-06462b9cb8aa"
}
