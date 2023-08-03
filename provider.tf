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
  // subscription_id = "798a62d7-06af-4dfe-b6f2-de906e046bed"
  // client_id       = "03ac8667-9625-46c6-becf-bf206d0cd680"
  // client_secret   = "bw28Q~b1wpcUgZRNm6BlHUvJxaz2qQXo5idJTcC2"
  // tenant_id       = "4ae54b05-b77e-4224-aef1-8661422e0816"
}