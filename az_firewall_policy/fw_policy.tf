resource "azurerm_firewall_policy" "fw_policy" {
  name                = var.fw_policy_name
  resource_group_name = var.fw_policy_rg
  location            = var.location
}