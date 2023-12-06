terraform {
  //required_version = ">=1.0"
  # required_providers {
  #   azurerm = {
  #     source  = "hashicorp/azurerm"
  #     version = ">=3.0.0"
  #   }
  backend "azurerm" {

    resource_group_name  = "Terraform-lab-rg"
    storage_account_name = "alcavdes1tsa1"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
  //   subscription_id = "5f94af94-2e21-425d-a715-e2b7df92f974"
  //   //client_id       = "03ac8667-9625-46c6-becf-bf206d0cd680"
  //   client_id = "bac0f6eb-ced4-4143-969e-5f6f46ff85f3"
  //   //client_secret   = "bw28Q~b1wpcUgZRNm6BlHUvJxaz2qQXo5idJTcC2"
  //   client_secret = "M7q8Q~ztLAjtQlFlC9948PbzWWp3IDC5gRegWbmI"
  //   tenant_id     = "4ae54b05-b77e-4224-aef1-8661422e0816"
  // }


}






