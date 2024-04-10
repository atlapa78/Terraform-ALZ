# Define a virtual network
resource "azurerm_virtual_network" "alz_vnet" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = var.rgname
  address_space       = var.address_space
  tags                = var.tags_rsrc
}


