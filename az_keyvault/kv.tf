resource "azurerm_key_vault" "keyvault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.rgname
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = var.tags_rsrc
  # access_policy {
  #   tenant_id = var.tenant_id
  #   object_id = var.object_id
  #   key_permissions    = var.key_permissions
  #   secret_permissions = var.secret_permissions
  # }
}


resource "azurerm_key_vault_access_policy" "accesspolicy_sp" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id
  //object_id    = "d223ee36-0475-4dbb-b3f0-96d8d8a65363"
  key_permissions    = var.key_permissions
  secret_permissions = var.secret_permissions
}

resource "azurerm_key_vault_access_policy" "accesspolicy_user" {
  key_vault_id       = azurerm_key_vault.keyvault.id
  tenant_id          = var.tenant_id
  object_id          = "d223ee36-0475-4dbb-b3f0-96d8d8a65363"
  key_permissions    = var.key_permissions
  secret_permissions = var.secret_permissions
}

