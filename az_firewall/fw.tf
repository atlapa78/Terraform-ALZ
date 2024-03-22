resource "azurerm_firewall" "firewall" {
  name                = var.fw_name
  location            = var.location
  resource_group_name = var.rgname
  sku_name            = var.fw_sku_name
  sku_tier            = var.fw_sku_tier

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.fw_subnet_id
    public_ip_address_id = var.fw_pip_id
  }
}