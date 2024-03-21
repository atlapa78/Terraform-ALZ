resource "azurerm_route_table" "subnet-rt" {
  location                      = var.location
  resource_group_name           = var.rgname
  for_each                      = toset([for i in values(var.subnets) : i.name if i.create_rt])
  name                          = tostring("${each.value}-rt")  
 
  disable_bgp_route_propagation = false
  route {
    name           = tostring("${each.value}-rt")
    address_prefix = var.address_space[0]
    next_hop_type  = "VnetLocal"
  }
}

