resource "azurerm_subnet" "az_subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rgname
  virtual_network_name = var.vnet
  address_prefixes     = var.address_space
}
