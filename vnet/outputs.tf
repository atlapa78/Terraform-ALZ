output "vnet_name" {
  value = azurerm_virtual_network.hubvnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.hubvnet.id
}

output "subnetiddc" {
  value = azurerm_virtual_network.hubvnet.subnet.*.id[0]
}