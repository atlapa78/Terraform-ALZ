resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each = var.rt_associations
  subnet_id = each.key
  route_table_id = each.value
}