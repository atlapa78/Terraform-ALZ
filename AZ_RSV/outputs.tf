output "rg_name" {
  value = azurerm_recovery_services_vault.vault.resource_group_name
}

output "vault_name" {
  value = azurerm_recovery_services_vault.vault.name
}