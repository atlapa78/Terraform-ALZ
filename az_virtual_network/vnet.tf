locals { 
  subnet_ids             = tolist([for subnet in azurerm_virtual_network.az_vnet.subnet : subnet.id ]) 
  //rt_ids                 = tolist([for rt in azurerm_route_table.subnet-rt : rt.id])
  subnets                = tolist([for i in values(var.subnets) : i.name if i.create_rt])
  # rt_associations        = tomap({
  #   subnet_id = flatten([for subname in local.subnets : [ for subid in local.subnet_ids : subid if strcontains(subid,subname)]])
  #   rt_id     = flatten([for subname in local.subnets : [ for rtid in local.rt_ids : rtid if strcontains(rtid,subname)]])
  # })
  # rt_sub_associations   = zipmap(values(local.rt_associations)[1], values(local.rt_associations)[0])
}

resource "azurerm_network_security_group" "vnet-nsg" {
  location                      = var.location
  resource_group_name           = var.rgname
  for_each                      = toset([for i in values(var.subnets) : i.security_group if i.creatensg])
  name                          = tostring(each.value)
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
      security_group            = subnet.value.name != "FirewallSubnet" && subnet.value.name != "GatewaySubnet" && length(values(azurerm_network_security_group.vnet-nsg)) != 0 ? element([for i in values(azurerm_network_security_group.vnet-nsg) : i.id if trimsuffix(i.name, "-nsg") != "" && trimsuffix(i.name, "-nsg") == subnet.value.name], 0) : null
      //security_group = [for i in values(azurerm_network_security_group.alznsg) : i.id if trimsuffix(i.name,"-nsg") != "" &&  trimsuffix(i.name,"-nsg") == subnet.value.name] !=0 ? element([for i in values(azurerm_network_security_group.alznsg) : i.id if trimsuffix(i.name,"-nsg") != "" &&  trimsuffix(i.name,"-nsg") == subnet.value.name],0) : null                       
    }
  }
  tags                          = var.tags_rsrc
  depends_on                    = [
    azurerm_network_security_group.vnet-nsg
  ]
}

# resource "azurerm_route_table" "subnet-rt" {
#   location                      = var.location
#   resource_group_name           = azurerm_virtual_network.az_vnet.resource_group_name
#   for_each                      = toset([for i in values(var.subnets) : i.name if i.create_rt])
#   name                          = tostring("${each.value}-rt")  
 
#   disable_bgp_route_propagation = false
#   route {
#     name           = tostring("${each.value}-rt")
#     address_prefix = var.address_space[0]
#     next_hop_type  = "VnetLocal"
#   }
# }

# resource "azurerm_subnet_route_table_association" "rt_association" {
#   for_each = local.rt_sub_associations
#   subnet_id = each.key
#   route_table_id = each.value
#   depends_on = [
#     azurerm_virtual_network.az_vnet, azurerm_route_table.subnet-rt
#   ]
# }

# output "subnetids" {
#   value = index(azurerm_virtual_network.az_vnet.subnet[*].name, "GatewaySubnet")
# }

output "nsgids" {
  value = keys(azurerm_network_security_group.vnet-nsg)
}

output "subnet_ids" {
  value = local.subnet_ids
}

# output "rt_ids" {
#   value = local.rt_ids
# }

# output "subnetnames" {
#   value    = flatten([for subname in local.subnets : [ for subid in local.subnet_ids : subid if strcontains(subid,subname)]])
# }

# output "rtnames" {
#   value    = flatten([for subname in local.subnets : [ for rtid in local.rt_ids : rtid if strcontains(rtid,subname)]])
# }

# output "rtassociations"{
#  value = local.rt_sub_associations
# }
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


