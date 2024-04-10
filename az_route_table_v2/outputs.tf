output "route_tables" {
  value = azurerm_route_table.subnet-rt
}

output "id" {
  value = azurerm_route_table.subnet-rt.id
}