
resource "azurerm_log_analytics_workspace" "laws" {
  name                = var.laws_name
  location            = var.location
  resource_group_name = var.rgname
  sku                 = var.laws_sku
  retention_in_days   = var.retention_days
  tags                = var.tags_rsrc
}