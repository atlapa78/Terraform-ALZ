output "vnet_name" {
  value = azurerm_virtual_network.avdvnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.avdvnet.id
}

output "subnetiddc" {
  value = azurerm_virtual_network.avdvnet.subnet.*.id[0]
}