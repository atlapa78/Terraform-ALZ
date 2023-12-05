resource "azurerm_resource_group" "lawsrg" {
  name     = var.rgname
  location = var.location
  tags     = var.tags_rg
}
