
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storageaccountname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  tags                     = var.tags_rsrc
}