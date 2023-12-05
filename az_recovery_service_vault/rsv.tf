resource "azurerm_recovery_services_vault" "vault" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.rgname
  sku                 = var.rsv_sku
  tags                = var.tags_rsrc
  soft_delete_enabled = true
}