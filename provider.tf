terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.54.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

  }
}

provider "azurerm" {
  features {}
  subscription_id = "5f94af94-2e21-425d-a715-e2b7df92f974"
  client_id       = "bac0f6eb-ced4-4143-969e-5f6f46ff85f3"
  client_secret   = "M7q8Q~ztLAjtQlFlC9948PbzWWp3IDC5gRegWbmI"
  tenant_id       = "4ae54b05-b77e-4224-aef1-8661422e0816"
}