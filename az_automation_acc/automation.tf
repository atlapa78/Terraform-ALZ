resource "azurerm_automation_account" "automation_acc" {
  name                = var.auto_name
  location            = var.location
  resource_group_name = var.rgname
  sku_name            = var.aut_acc_sku
  tags                = var.tags_rsrc
}