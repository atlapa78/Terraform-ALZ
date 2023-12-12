resource "azurerm_network_security_group" "vnet-nsg" {
  location                      = var.location
  resource_group_name           = var.rgname
  //name = element([for nsg in values(var.subnets) : nsg.security_group if nsg.createsg == true],0)
  for_each                      = toset([for i in values(var.subnets) : i.security_group if i.creatensg])
  name                          = tostring(each.value)
  # for_each = var.subnets    
  #   name = each.value.createsg ? each.value.security_group : ""
}

resource "azurerm_virtual_network" "az_vnet" {
  #name                = lower("${var.CustomerID}-${var.environment}-${var.regions[var.location]}-vnet")
  name                          = var.vnetname
  location                      = var.location
  resource_group_name           = var.rgname
  address_space                 = var.address_space
  
  dynamic "subnet" {
    for_each                    = var.subnets
    content {
      name                      = subnet.value.name
      address_prefix            = subnet.value.address_prefix
      
      //security_group            = subnet.value.name != "FirewallSubnet" && subnet.value.name != "GatewaySubnet" && length(values(azurerm_network_security_group.vnet-nsg)) != 0 ? element([for i in values(azurerm_network_security_group.vnet-nsg) : i.id if trimsuffix(i.name, "-nsg") != "" && trimsuffix(i.name, "-nsg") == subnet.value.name], 0) : null
      //security_group = [for i in values(azurerm_network_security_group.alznsg) : i.id if trimsuffix(i.name,"-nsg") != "" &&  trimsuffix(i.name,"-nsg") == subnet.value.name] !=0 ? element([for i in values(azurerm_network_security_group.alznsg) : i.id if trimsuffix(i.name,"-nsg") != "" &&  trimsuffix(i.name,"-nsg") == subnet.value.name],0) : null                       
    }
  }
  tags                          = var.tags_rsrc
  depends_on                    = [
    azurerm_network_security_group.vnet-nsg
  ]
}

resource "azurerm_route_table" "sharedrt" {
  name                          = "shared-rt"
  location                      = var.location
  resource_group_name                 = azurerm_virtual_network.az_vnet.resource_group_name
  disable_bgp_route_propagation = false
  route {
    name           = "sharedrt"
    address_prefix = "10.41.0.0/22"
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "sharedrtasso" {
  subnet_id      = element(azurerm_virtual_network.az_vnet.subnet[*].id, 5)
  route_table_id = azurerm_route_table.sharedrt.id
  depends_on = [
    azurerm_virtual_network.az_vnet
  ]
}

# output "subnetids" {
#   value = index(azurerm_virtual_network.az_vnet.subnet[*].name, "GatewaySubnet")
# }

output "nsgids" {
  value = keys(azurerm_network_security_group.vnet-nsg)
}



# resource "azurerm_network_security_rule" "nsgrules" {
#     for_each                   = local.nsgrules
#       name                        = each.key
#       direction                   = each.value.direction
#       access                      = each.value.access
#       priority                    = each.value.priority
#       protocol                    = each.value.protocol
#       source_port_range           = each.value.source_port_range
#       destination_port_range      = each.value.destination_port_range
#       destination_address_prefix  = each.value.destination_address_prefix
#       resource_group_name         = azurerm_resource_group.avdrg.name
#       network_security_group_name = azurerm_network_security_group.avdnsg.name
#   }


