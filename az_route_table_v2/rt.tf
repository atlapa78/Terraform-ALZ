resource "azurerm_route_table" "subnet-rt" {
  location                      = var.location
  resource_group_name           = var.rgname
  name                          = var.rt_name
  disable_bgp_route_propagation = false
  route {
    name           = "to_fw"
    address_prefix = var.address_space
    next_hop_type  = "VnetLocal"
  }
}

