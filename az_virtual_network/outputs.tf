output "vnet_name" {
  value = azurerm_virtual_network.az_vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.az_vnet.id
}

output "subnetiddc" {
  value = azurerm_virtual_network.az_vnet.subnet.*.id[0]
}

output "subnetlbid" {
  value = [for subnet in azurerm_virtual_network.az_vnet.subnet : subnet.id if subnet.name == "LBsubnet"]
}


output "gatewayid" {
  value = [for subnet in azurerm_virtual_network.az_vnet.subnet : subnet.id if subnet.name == "GatewaySubnet"]
}
output "subnets" {
  value = azurerm_virtual_network.az_vnet.subnet
}

# output "route_tables" {
#   value = azurerm_route_table.subnet-rt
# }