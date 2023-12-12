output "vnet_name" {
  value = azurerm_virtual_network.hubvnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.hubvnet.id
}

output "subnetiddc" {
  value = azurerm_virtual_network.hubvnet.subnet.*.id[0]
}

output "subnetlbid" {
  value = [for subnet in azurerm_virtual_network.hubvnet.subnet : subnet.id if subnet.name == "LBsubnet"]
}


output "gatewayid" {
  value = [for subnet in azurerm_virtual_network.hubvnet.subnet : subnet.id if subnet.name == "GatewaySubnet"]
}
output "subnets" {
  value = azurerm_virtual_network.hubvnet.subnet
}