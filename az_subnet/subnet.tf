resource "azurerm_subnet" "az_subnet" {
  for_each = var.subnets
  name                 = each.value.name
  resource_group_name  = var.rgname
  virtual_network_name = var.vnet
  address_prefixes     = [each.value.address_prefix]




#   delegation {
#     name = "delegation"

#     service_delegation {
#       name    = "Microsoft.ContainerInstance/containerGroups"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
#     }
#   }
}