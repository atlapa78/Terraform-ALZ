resource "random_string" "password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}


resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.keyvault_secret_name
  value        = random_string.password.result
  key_vault_id = var.key_vault_id
  tags         = var.tags_rsrc
}


